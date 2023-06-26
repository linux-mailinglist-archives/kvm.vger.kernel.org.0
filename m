Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D02073EC3A
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 22:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbjFZUy5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 16:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbjFZUyt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 16:54:49 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12237AA;
        Mon, 26 Jun 2023 13:54:48 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-666eba6f3d6so1959505b3a.3;
        Mon, 26 Jun 2023 13:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687812887; x=1690404887;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SLX8BQCbnM9f/rd4hNlD65VtEQzgDwt/qNhvu2U5O+o=;
        b=O7Rlv3HO3y2p/neIeiX+WcXeKkYRkH/Hud4oWFA5Kwnfa7VEzewyTactXTn9BMWagn
         vrgIqVvhLsl3179GwpoERag7EPwtBJrx8guHw0/h9isty9OZtlzTXWOQqt6wIyTK7L3R
         7LqIPfKbIaZELhFwvp7OqI4uMUunijs8eZh9Gk+Iqh0L7jXDE4rrszK08tfI6fWAfYwR
         mFu/EUKnXHMceb/jyadLdvnj1b1saB+NlU3mK3g9cnflr0SBspqYYbUn5HAb2Wmfklcc
         jeCjTeriif9cUxUs9GOkzRl2kY2uRZgfjhurVA0h57pkEFeIUB0RFZT1iPLhwt5Mh3C2
         IV0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687812887; x=1690404887;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SLX8BQCbnM9f/rd4hNlD65VtEQzgDwt/qNhvu2U5O+o=;
        b=bm1tcHWTeWpppCLJZ33i8XWB4zRPlSjux1a1pPQQtH9FX+pI+0CKH/WeH19f5Fylac
         BNlUVGzeLVUDui130LPknzF/2VLPToQ5V+1BjSPhnpsnTiPRLCE79zjTY+8nX2aJxNut
         6WEKOLMNdQG8S6wwgXf8QFPMGGqKLvroO3XKx0iDcKc8Ag9sHJOrREwAGYRrYlHQ1LU/
         ERRL58izLfO7gCUJh2vQdix+Ae3tol9m9MyLhAFpg+oavZCdm9Oeqfrd4rETe63PY7IC
         Df3N8+9AWV77zrxW8AIMQL+Bntj4r+1z8lOpVbsrq9hsjkB5AG/+s7BGrFsn4PElKO8E
         C18A==
X-Gm-Message-State: AC+VfDz8hWN9X7r8cWv4jO3GTwVcgYSevi35m0pxWgljOOHrpsBry43/
        mvj3cyaKHEYbZ3KJnZA4swrEnXKQAWk=
X-Google-Smtp-Source: ACHHUZ7QMKlAdDcizoc4NRAdtXPlF4YVpNcKhSVQ4cUkFFQT3MDj4GDlmbTFg4KOOawQON5+rFuebg==
X-Received: by 2002:a05:6a00:2394:b0:668:73f5:dce0 with SMTP id f20-20020a056a00239400b0066873f5dce0mr18699094pfc.29.1687812887340;
        Mon, 26 Jun 2023 13:54:47 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id t16-20020aa79390000000b0065dd1e7c3c2sm4202467pfe.184.2023.06.26.13.54.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jun 2023 13:54:46 -0700 (PDT)
Date:   Mon, 26 Jun 2023 13:54:45 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Michael Roth <michael.roth@amd.com>
Subject: Re: [RFC PATCH 0/6] KVM: guest memory: Misc enhacnement
Message-ID: <20230626205445.GD3436214@ls.amr.corp.intel.com>
References: <cover.1686858861.git.isaku.yamahata@intel.com>
 <ZJY0Nudy8ym2kKNg@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZJY0Nudy8ym2kKNg@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 23, 2023 at 05:09:26PM -0700,
Sean Christopherson <seanjc@google.com> wrote:

> On Thu, Jun 15, 2023, isaku.yamahata@intel.com wrote:
> > * VM type: Now we have KVM_X86_PROTECTED_VM. How do we proceed?
> >   - Keep KVM_X86_PROTECTED_VM for its use. Introduce KVM_X86_TDX_VM
> >   - Use KVM_X86_PROTECTED_VM for TDX. (If necessary, introduce another type in
> >     the future)
> 
> How would KVM differentiate between software-protected VMs and TDX VMs if we go
> with this option?

Let's introduce new two VM type.  I'm fine with two new VM types.  I had KVM
capability in mind if SEV implementation doesn't like new VM types.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
