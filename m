Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9A5E55DE8F
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243204AbiF1Bmq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 21:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243298AbiF1Bmp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 21:42:45 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065561EED3
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 18:42:44 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id i8-20020a17090aee8800b001ecc929d14dso11320724pjz.0
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 18:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=4lLfjfwPPbIX8sN3+ft8fQgLm3d5W4sVy9tGhjVySIo=;
        b=BaENut5SKl7hCIgbGPX4FwMh0/tDPD8Ze2gquwl82RJB111PVcgjY456qwm12NcmQx
         FRomZMt4U9iI69g3P3wahRKMWLIUU1GIZ0LMqs9oyYW2vkpJHlEa2+ijXJDxeyHfhra4
         JKA/REsjqMQf4JfEKYCShFfjw8Dv+4mNvQ1JxzhCcbZghBjYyo8u0/kTw1RKrnCaGmiD
         tNwA+uRJz6d34GRxf7KLz4aLhCQfl8wRH7uAFV4JqUXVF3biCNwNZKZ7oGATIZ4k+ZeL
         HAqDUn8+W4rj+d6071W30BzpsHoYZR937gDB1NHL4BIVcItGDEDi01IpPTvjYE+1fUBw
         DLjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=4lLfjfwPPbIX8sN3+ft8fQgLm3d5W4sVy9tGhjVySIo=;
        b=19hw/xTcBbd7bBo/DLahXi2H14eNTD/RtebS+HUH5pLnM6+alsGefwspglL3j7uMiN
         kM/jlH8tDdF5Uh4+3YVWD8YOhNLoWk3zcE7eVd4Fcn+rR0skEIgNDo+SjQ1E8dqKIFom
         NKeIzfB16xrIwx81dP9N364jakB3sztvYMV9DMxkS0/QPmqbIRmmbgJg4fSMY0iP2bPn
         Vb+XrR5WiIfJxdnf90WAuBehWzWC310+KGlspq3oA9Lyglk+WRoiZ2Y3vBjoWS5WaptK
         LWMOLB2rWtdRikhHYWhlG24jUkYySptFgC7FDJCilAIxwgqHY0mMSBk0CKGzNUZkfFE+
         JHPQ==
X-Gm-Message-State: AJIora+u1eW64gCYJ1rI6pLxEzXF+kmgXwA2hxuuZhE/SC2VvO7YfqPs
        sHesbGBTpA98632k3JOAflzlXJ/XqjAbvQ==
X-Google-Smtp-Source: AGRyM1trgPP+wIFJY3okx/e0bKBriJbvbJvyNHXpOa8rOLcY8FgCzINkelfSSo9DDxY/a1mXekpeTA==
X-Received: by 2002:a17:902:f602:b0:16a:178a:7b0b with SMTP id n2-20020a170902f60200b0016a178a7b0bmr2475399plg.20.1656380563370;
        Mon, 27 Jun 2022 18:42:43 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id i14-20020a62870e000000b005251ce498cfsm7912699pfe.191.2022.06.27.18.42.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jun 2022 18:42:42 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [Bug 216177] kvm-unit-tests vmx has about 60% of failure chance
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <bug-216177-28872-0HfdJRGX5a@https.bugzilla.kernel.org/>
Date:   Mon, 27 Jun 2022 18:42:41 -0700
Cc:     kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <5D5DBC33-EDD0-4FB8-A0D6-F1DE9CA56FFF@gmail.com>
References: <bug-216177-28872@https.bugzilla.kernel.org/>
 <bug-216177-28872-0HfdJRGX5a@https.bugzilla.kernel.org/>
To:     bugzilla-daemon@kernel.org
X-Mailer: Apple Mail (2.3696.100.31)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Jun 27, 2022, at 6:19 PM, bugzilla-daemon@kernel.org wrote:
>=20
> https://bugzilla.kernel.org/show_bug.cgi?id=3D216177
>=20
> --- Comment #3 from Yang Lixiao (lixiao.yang@intel.com) ---
> (In reply to Nadav Amit from comment #2)
>>> On Jun 27, 2022, at 5:28 PM, bugzilla-daemon@kernel.org wrote:
>>>=20
>>> https://bugzilla.kernel.org/show_bug.cgi?id=3D216177
>>>=20
>>> Sean Christopherson (seanjc@google.com) changed:
>>>=20
>>>          What    |Removed                     |Added
>>>=20
>> =
--------------------------------------------------------------------------=
--
>>>                CC|                            |seanjc@google.com
>>>=20
>>> --- Comment #1 from Sean Christopherson (seanjc@google.com) ---
>>> It's vmx_preemption_timer_expiry_test, which is known to be flaky =
(though
>>> IIRC
>>> it's KVM that's at fault).
>>>=20
>>> Test suite: vmx_preemption_timer_expiry_test
>>> FAIL: Last stored guest TSC (28067103426) < TSC deadline =
(28067086048)
>>=20
>> For the record:
>>=20
>> =
https://lore.kernel.org/kvm/D121A03E-6861-4736-8070-5D1E4FEE1D32@gmail.com=
/
>=20
> Thanks for your reply. So this is a KVM bug, and you have sent a patch =
to kvm
> to fix this bug, right?

As I noted, at some point I did not manage to reproduce the failure.

The failure on bare-metal that I experienced hints that this is either a =
test
bug or (much less likely) a hardware bug. But I do not think it is =
likely to be
a KVM bug.

