Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37891700706
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 13:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240735AbjELLl5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 07:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240407AbjELLly (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 07:41:54 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B781BFB
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 04:41:48 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-9661a1ff1e9so1158755166b.1
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 04:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683891707; x=1686483707;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qPdxhncpdA+Cs9nKW55LIueGY421O1IzKmKeIEN1D68=;
        b=B54E/SzpioqAy+SaZKZ7nHGc9JhanoYi/NmSnKkM1PJYhorznhxRg/R8Jm6DrdU8bp
         27rF8BkGsJ9r5Z1g+JN+iYghBkkmCIEqQdR0PDJYVoTLoctUbT2hWhk/BlMUcnDg09GJ
         OQ+K/1hkzwgPKN/9Sna+QA/0qSsXh4kxQmsd3vt16GfcK4VnRcE9Fg0964aUb4ZOwMJP
         u75hofr08BV+MgY33gu+dIMNPKlntNWJ6SuqGZraoHFRwOUd0GppTvvhRzysr3dBoweG
         vREERfKUl1044VlHY+ytn2lHxp4oD8lOFPa1x9iLthqMypJWd4pQFbJEyjxubX0fcUTA
         TMyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683891707; x=1686483707;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qPdxhncpdA+Cs9nKW55LIueGY421O1IzKmKeIEN1D68=;
        b=MjlD+e84DBwsj6+CfvovTk8R7/ChD7TPVoSr12IW9dG9I5YRTOUJNdnmL6LnnEyNRW
         E2ULUjwVW6KGFrYn0sBhc7nAU+Gp25wFKZBH3IdfUqipaWWKYtJEohRxyb9E1JRYBpgu
         pb8kkPiKnBvWhpo67oly6IcSXXIRLJ+KAfG9zXtkCNnc4fpCkg8fxirE6iJLII9cPpRG
         RxyD0COakqOg+t+mqK/TF/Pacll1pIKnH13X5sw9SHkDiZMBYtzZvat6iUzcZ1aMEouv
         ti+TvFM91IlZ+/w5K4EZYYW3mtBQPSnM5R89cZBvnC3dviwELUbMdW9iulfBkc4DB35u
         dSaA==
X-Gm-Message-State: AC+VfDxV2p2v0DavyexEaSRHKI9azOq6lSQIWp1x7beaCjPsRVww0TmL
        qC9nN++RWB2HntC+3z7Awmo=
X-Google-Smtp-Source: ACHHUZ7pM9AwKK8bNdvT2P5gNzceT7y5E9mNBGR2nnohVSCTa/7UJG9PRG9odbvmrdQLrfdNxUnlKQ==
X-Received: by 2002:a17:907:7293:b0:969:dda1:38a4 with SMTP id dt19-20020a170907729300b00969dda138a4mr13652128ejc.38.1683891707122;
        Fri, 12 May 2023 04:41:47 -0700 (PDT)
Received: from [127.0.0.1] (dynamic-077-013-129-055.77.13.pool.telefonica.de. [77.13.129.55])
        by smtp.gmail.com with ESMTPSA id n10-20020aa7db4a000000b005027d31615dsm3788662edt.62.2023.05.12.04.41.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 May 2023 04:41:46 -0700 (PDT)
Date:   Fri, 12 May 2023 11:41:33 +0000
From:   Bernhard Beschow <shentey@gmail.com>
To:     quintela@redhat.com, Juan Quintela <quintela@redhat.com>,
        afaerber@suse.de
CC:     ale@rev.ng, anjo@rev.ng, bazulay@redhat.com, bbauman@redhat.com,
        chao.p.peng@linux.intel.com, cjia@nvidia.com, cw@f00f.org,
        david.edmondson@oracle.com, dustin.kirkland@canonical.com,
        eblake@redhat.com, edgar.iglesias@gmail.com,
        elena.ufimtseva@oracle.com, eric.auger@redhat.com, f4bug@amsat.org,
        Felipe Franciosi <felipe.franciosi@nutanix.com>,
        "iggy@theiggy.com" <iggy@kws1.com>, Warner Losh <wlosh@bsdimp.com>,
        jan.kiszka@web.de, jgg@nvidia.com, jidong.xiao@gmail.com,
        jjherne@linux.vnet.ibm.com, joao.m.martins@oracle.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org,
        mburton@qti.qualcomm.com, mdean@redhat.com,
        mimu@linux.vnet.ibm.com, peter.maydell@linaro.org,
        qemu-devel@nongnu.org, richard.henderson@linaro.org,
        shameerali.kolothum.thodi@huawei.com, stefanha@gmail.com,
        wei.w.wang@intel.com, z.huo@139.com, zwu.kernel@gmail.com
Subject: Re: QEMU developers fortnightly call for agenda for 2023-05-16
In-Reply-To: <871qjm3su8.fsf@secure.mitica>
References: <calendar-f9e06ce0-8972-4775-9a3d-7269ec566398@google.com> <871qjm3su8.fsf@secure.mitica>
Message-ID: <452B32A5-8C9E-4A61-B14B-C8AB47D0A3ED@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 12=2E Mai 2023 07:35:27 UTC schrieb Juan Quintela <quintela@redhat=2Eco=
m>:
>juan=2Equintela@gmail=2Ecom wrote:
>> Hi If you are interested in any topic, please let me know=2E Later, Jua=
n=2E
>
>Hi folks
>
>So far what we have in the agenda is:
>
>questions from Mark:
>- Update on single binary?
>- What=E2=80=99s the status on the =E2=80=9Cicount=E2=80=9D plugin ?
>- Also I could do with some help on a specific issue on KVM/HVF memory ha=
ndling
>
>From me:
>- Small update on what is going on with all the migration changes
>
>Later, Juan=2E
>
>
>> QEMU developers fortnightly conference call
>> Tuesday 2023-05-16 =E2=8B=85 15:00 =E2=80=93 16:00
>> Central European Time - Madrid
>>
>> Location
>> https://meet=2Ejit=2Esi/kvmcallmeeting=09

Hi Juan,

Would it be possible to offer a public calendar entry -- perhaps in =2Eics=
 format -- with above information? Which can be conveniently subscribed to =
via a smartphone app? Which gets updated regularly under the same link? Whi=
ch doesn't (needlessly, anyway) require authentcation?=20

Thanks,
Bernhard

>> https://www=2Egoogle=2Ecom/url?q=3Dhttps%3A%2F%2Fmeet=2Ejit=2Esi%2Fkvmc=
allmeeting&sa=3DD&ust=3D1684065960000000&usg=3DAOvVaw14RNXU52XvArxijoKSmVbR
>>
>>
>>
>> If you need call details, please contact me: quintela@redhat=2Ecom
>>
>> Guests
>> Philippe Mathieu-Daud=C3=A9
>> Joao Martins
>> quintela@redhat=2Ecom
>> Meirav Dean
>> Felipe Franciosi
>> afaerber@suse=2Ede
>> bazulay@redhat=2Ecom
>> bbauman@redhat=2Ecom
>> cw@f00f=2Eorg
>> dustin=2Ekirkland@canonical=2Ecom
>> eblake@redhat=2Ecom
>> edgar=2Eiglesias@gmail=2Ecom
>> eric=2Eauger@redhat=2Ecom
>> iggy@theiggy=2Ecom
>> jan=2Ekiszka@web=2Ede
>> jidong=2Exiao@gmail=2Ecom
>> jjherne@linux=2Evnet=2Eibm=2Ecom
>> mimu@linux=2Evnet=2Eibm=2Ecom
>> Peter Maydell
>> richard=2Ehenderson@linaro=2Eorg
>> stefanha@gmail=2Ecom
>> Warner Losh
>> z=2Ehuo@139=2Ecom
>> zwu=2Ekernel@gmail=2Ecom
>> Jason Gunthorpe
>> Neo Jia
>> David Edmondson
>> Elena Ufimtseva
>> Konrad Wilk
>> ale@rev=2Eng
>> anjo@rev=2Eng
>> Shameerali Kolothum Thodi
>> Wang, Wei W
>> Chao Peng
>> kvm-devel
>> qemu-devel@nongnu=2Eorg
>> mburton@qti=2Equalcomm=2Ecom
>
>
