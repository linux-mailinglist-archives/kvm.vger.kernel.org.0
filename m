Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8EF6C8782
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 22:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbjCXVdM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 17:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjCXVdL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 17:33:11 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF051A4AB
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 14:33:08 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id 16-20020a056a00071000b00627e9b4871eso1573998pfl.11
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 14:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679693588;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IwqIwv/tqLiASfdNBOtwEIEJYiaaWmQZ93Bhvs67JGQ=;
        b=OIPfQ5hZVDJHUQ1cSW77jctoIXVTpbXLH1is/tZE2O1XfProT+a3dvD8u1FzOEf5ZV
         JFU9CPp78hu4VYiSgoy029WjYqW36ZtPrMWPxAsT7DixBtPhRdWw4vEZjL9sEEzPdjYb
         Bu0ZOw44UuqO9JBpIlpZxPKvSvJAodiHrgTWqhM3fPwckbpT1XIwSjR93eegagK2oQqm
         4ZY1zTnoOATBSmFspDxOhLhOzGTMKg2nzVMkEhGcTZ9E6BSU+SsG7WzyQbkk9TT8G0Df
         sQCm3IeUWa6dZXbmf9R5WEBCbhw7wQaOKReZnC0x1Q/TSW3eGv6+xLk1+NAQ8hTPSH4c
         1hJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679693588;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IwqIwv/tqLiASfdNBOtwEIEJYiaaWmQZ93Bhvs67JGQ=;
        b=ku2ssqhVPNaNRuHYMaCtb2F15/Xne2XKIoBAIoHtiubOJm6BxJVuFGsFxlzrOs9H4f
         AVdrkpq9+Nx8chFJChMFBV59b0q9qWNQeC7xueXNJvU20xSrpWxb88zzIA4LCOqgQEZU
         aT2xt5/d2j/MovnYGRZgEmm/nUcsa+5KbwCYcxg062H/JrVUW+bhWqoyTAFr2JEtbZJ5
         6/K8akK+blvYHZOv4hI6K4rxIvBTwUKo0vYkrDIfD2l42dw8aDGG8RYtQAehAolFidjU
         0Oq3zkZRgaDqKIT3ENWgBkfj+Dq7h2ZiVSFaHEf+h19+zia9o01FeYyl2ECyrYtNv6KU
         2bxQ==
X-Gm-Message-State: AAQBX9cc/Cwq/eFKMcsmYUPigv18J0Vy504cLtLJZCOLs6NrabDxQKHG
        e7K0aElp3Z+Yy4sgS3bXh2Ezn3LehRs=
X-Google-Smtp-Source: AKy350aQM1Ru4OKWaay1ah7w1ErMxIg9e8pk6GVoOvCFEK9Q8i70sf+Y+u16TQBCc2MBGtY74ApaJs2UeT0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2385:b0:5aa:310c:e65b with SMTP id
 f5-20020a056a00238500b005aa310ce65bmr2334505pfc.2.1679693588421; Fri, 24 Mar
 2023 14:33:08 -0700 (PDT)
Date:   Fri, 24 Mar 2023 14:32:48 -0700
In-Reply-To: <20230322144528.704077-1-ivan.orlov0322@gmail.com>
Mime-Version: 1.0
References: <20230322144528.704077-1-ivan.orlov0322@gmail.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <167969290615.2764662.14384745948331970319.b4-ty@google.com>
Subject: Re: [PATCH] selftests: kvm: Add 'malloc' failure check in vcpu_save_state
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
        shuah@kernel.org, dmatlack@google.com, vannapurve@google.com,
        Ivan Orlov <ivan.orlov0322@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, himadrispandya@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 22 Mar 2023 18:45:28 +0400, Ivan Orlov wrote:
> There is a 'malloc' call in vcpu_save_state function, which can
> be unsuccessful. This patch will add the malloc failure checking
> to avoid possible null dereference and give more information
> about test fail reasons.
> 
> 

Applied to kvm-x86 selftests, thanks!

[1/1] selftests: kvm: Add 'malloc' failure check in vcpu_save_state
      https://github.com/kvm-x86/linux/commit/735b0e0f2d00

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
