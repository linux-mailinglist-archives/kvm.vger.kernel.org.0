Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75D1E6F032F
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 11:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243136AbjD0JP4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 05:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233094AbjD0JPy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 05:15:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6004FE50
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 02:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682586915;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=v7UuP4nuUeZ3B3+0Kabr5KMbpfNy0I0Wpl8bvEPWf4U=;
        b=NtLHyyyqxn1Km8VX+H04BS2HC1fBWoUW0Ih4HVYOmw7QzrahBko2fhBaICoL2NFdpkUS3E
        495Hpluxe3e7AAD4509Qfbtt6Q6QKxFtOP9YtOok7gdee9D3ZqK1EHVqVUluQ3VjPLanEG
        ac3RZ4XghOGM8o1XrLhCOr+mXjUoK/s=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-6sJuxR13OgK2SBv2WOKs4w-1; Thu, 27 Apr 2023 05:15:13 -0400
X-MC-Unique: 6sJuxR13OgK2SBv2WOKs4w-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-2f55f0626a6so3037086f8f.3
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 02:15:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682586912; x=1685178912;
        h=mime-version:message-id:date:reply-to:user-agent:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v7UuP4nuUeZ3B3+0Kabr5KMbpfNy0I0Wpl8bvEPWf4U=;
        b=hVrCxY5ipO+uXtsOmP0luQmtTTP67ARl7XvCqOcy7I1PLtF1rG+ZfjesiAcFq9w6X6
         HPInIDPLMB3lbytsq471qcTSBXsTkuww5CcJOYEbNDbLR2wJlNrBm5hWF6/PtUHTJG2Q
         9nkxbLZuu0BL86BI7X2ahegT8EAhFD8oQX3EeTNasv9QkOTsJ/FJutxw7fdDMJ4865FU
         PKy7YQOJQE67zNurdKflO2F8qoT33Aat51GlCw65xhR8M1lzS9ErhAtrRU2BJspyYyzy
         d017BYhPDoMbv4XJx/fzxgdSiuM/kUjtCXD/lomzjQsUgz6taEREO5JcjO5ZXZH2DMbR
         JQAw==
X-Gm-Message-State: AC+VfDzOey8BofiR3abCR0E/kyVDqV9os2S0xswcVjxsbD+kytw8Rxqp
        hsJ1zJPh2zrTiDq9BY4xELkAzVqkvMHUWI+yMVdRGtunBrSoyTpl+4LiLiMHBFLkzh5ip4ax7YB
        e9IFK83ik2tbD
X-Received: by 2002:adf:fe02:0:b0:2d2:29a4:4457 with SMTP id n2-20020adffe02000000b002d229a44457mr834989wrr.13.1682586912522;
        Thu, 27 Apr 2023 02:15:12 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6s4kLUZUrULVianKT/LrUF2fjREferlMnoCnfQpblfBDcE60yz7+CW/iCcYmpVGT3bSnMpig==
X-Received: by 2002:adf:fe02:0:b0:2d2:29a4:4457 with SMTP id n2-20020adffe02000000b002d229a44457mr834939wrr.13.1682586912199;
        Thu, 27 Apr 2023 02:15:12 -0700 (PDT)
Received: from redhat.com (static-214-39-62-95.ipcom.comunitel.net. [95.62.39.214])
        by smtp.gmail.com with ESMTPSA id j32-20020a05600c1c2000b003f173987ec2sm24078844wms.22.2023.04.27.02.15.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 02:15:11 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     afaerber@suse.de
Cc:     ale@rev.ng, anjo@rev.ng, bazulay@redhat.com, bbauman@redhat.com,
        chao.p.peng@linux.intel.com, cjia@nvidia.com, cw@f00f.org,
        david.edmondson@oracle.com, Eric Northup <digitaleric@google.com>,
        dustin.kirkland@canonical.com, eblake@redhat.com,
        edgar.iglesias@gmail.com, elena.ufimtseva@oracle.com,
        eric.auger@redhat.com, f4bug@amsat.org,
        Felipe Franciosi <felipe.franciosi@nutanix.com>,
        "iggy@theiggy.com" <iggy@kws1.com>, Warner Losh <wlosh@bsdimp.com>,
        jan.kiszka@web.de, jgg@nvidia.com, jidong.xiao@gmail.com,
        jjherne@linux.vnet.ibm.com, joao.m.martins@oracle.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org,
        mburton@qti.qualcomm.com, mdean@redhat.com,
        mimu@linux.vnet.ibm.com, peter.maydell@linaro.org,
        qemu-devel@nongnu.org, richard.henderson@linaro.org,
        shameerali.kolothum.thodi@huawei.com, stefanha@gmail.com,
        wei.w.wang@intel.com, z.huo@139.com, zwu.kernel@gmail.com,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: Re: cal for agenda for QEMU developers fortnightly conference
 (20230502)
In-Reply-To: <calendar-73bf5f34-029a-4f98-aef4-652c1896beea@google.com> (juan
        quintela's message of "Thu, 27 Apr 2023 09:09:35 +0000")
References: <calendar-73bf5f34-029a-4f98-aef4-652c1896beea@google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Thu, 27 Apr 2023 11:15:10 +0200
Message-ID: <87cz3pd6u9.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi

Please, send any topic that you are interested in covering.

At the end of Monday I will send an email with the agenda or the
cancellation of the call, so hurry up.

If I remember correctly, last week philippe was not able to attend, but
there are something to discuss about single binary.

Anything else?

Thanks, Juan.

