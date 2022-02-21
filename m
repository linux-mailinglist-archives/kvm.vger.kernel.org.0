Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE2254BDF87
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356193AbiBUL1w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 06:27:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356245AbiBUL1u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 06:27:50 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF6B132
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 03:27:27 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id vz16so32529855ejb.0
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 03:27:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QfeSKBfr69eMqbyFaTz5YnZJH5NzZ8fhqbreHY3byjI=;
        b=MSznNC5HegD8Svgn4sUDS4Bu4iNOlm+gxU537OVUCVYrWtsWodnHSYSWmGoDZZDDqi
         1vEISyfUkc5LgW/NyTCo9Hjm1rEHSRWmObCSZxnAKC1Gl+D3fkEzewf+pbDdiOde+zq1
         EgmLSwJNC3EZJsXwxz6liaAtv19ws/xHUa95hblxD8ghqz35vWgLv2ZOAATxjU2349HA
         VI5GV58ueOBDMLo/VOtIu9Ku92TQdLzMn0vpUExTr77JzHHi/CagwLHEL8BvZXDsmzKO
         1FXn4qi7f33Zhkoh/V3HdzIogFdoVyQIuddVfhwasqBBFT8bkzbH+Qg7H7wN8KX7VATs
         sRIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QfeSKBfr69eMqbyFaTz5YnZJH5NzZ8fhqbreHY3byjI=;
        b=J4ev9n5mAGodTEXd6ZOziCRSq2roUSXIcDqXdUGfX2kfEcWhCwjuPaNP9+1OdUMt+J
         BgX/9ZwEtn99tyQmajb5QLovhn/u5i7r3nNC19YMqqTC9vEAt2WEU5y/paaRAEZYjBZu
         LjTqgW7MaeUMsSFZGbfzIwKboNav/YnCLK3hvmn8a7mv2GkfyvEngYtcG2h55M7e4xnt
         xZ8QUDsE1pvwLsW8iNYXxAJ1rcb/S71e+4huyhaAGNKz+LQ29DYCtC1F9dv1B/UKjgU9
         RG2K0ZqhP9D5quBHEiyKBelpQ2o5HpaJEafYr3GYIDo3/X23hDK2cNSebOhVlPnMTKNy
         wNCQ==
X-Gm-Message-State: AOAM533wzEfgpZU/VcmeSuSIyCG+f8EAuSz44xxqYrI1kveTmpAsDnLE
        UHXck4Tlz36fh8NYr4aEkGk=
X-Google-Smtp-Source: ABdhPJy1a1fr5rvP1zV+9Elve2Asci5szrpa6j1SxCnD+WZZ57oIEbX9PKf3IB3Lgi0fMneOzLQDaA==
X-Received: by 2002:a17:906:4d8d:b0:6ce:8c3d:6e81 with SMTP id s13-20020a1709064d8d00b006ce8c3d6e81mr14875391eju.205.1645442846235;
        Mon, 21 Feb 2022 03:27:26 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id r8sm8223822edt.65.2022.02.21.03.27.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 03:27:25 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <1b38c5ea-d908-fe36-05e1-022d402cedbc@redhat.com>
Date:   Mon, 21 Feb 2022 12:27:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2022
Content-Language: en-US
To:     =?UTF-8?B?TWljaGFsIFByw612b3puw61r?= <mprivozn@redhat.com>,
        Stefan Hajnoczi <stefanha@gmail.com>
Cc:     "libvir-list@redhat.com" <libvir-list@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>
References: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
 <f7dc638d-0de1-baa8-d883-fd8435ae13f2@redhat.com>
 <bf97384a-2244-c997-ba75-e3680d576401@redhat.com>
 <ad4e6ea2-df38-005a-5d60-375ec9be8c0e@redhat.com>
 <CAJSP0QVNjdr+9GNr+EG75tv4SaenV0TSk3RiuLG01iqHxhY7gQ@mail.gmail.com>
 <d2af5caf-5201-70aa-92cc-16790a8159d1@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <d2af5caf-5201-70aa-92cc-16790a8159d1@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/21/22 10:36, Michal Prívozník wrote:
> Indeed. Libvirt's participating on its own since 2016, IIRC. Since we're
> still in org acceptance phase we have some time to decide this,
> actually. We can do the final decision after participating orgs are
> announced. My gut feeling says that it's going to be more work on QEMU
> side which would warrant it to be on the QEMU ideas page.

There are multiple projects that can be done on this topic, some 
QEMU-only, some Libvirt-only.  For now I would announce the project on 
the Libvirt side (and focus on those projects) since you are comentoring.

Paolo
