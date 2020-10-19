Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 379E3292BE9
	for <lists+kvm@lfdr.de>; Mon, 19 Oct 2020 18:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730641AbgJSQw7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Oct 2020 12:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729879AbgJSQw7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Oct 2020 12:52:59 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 689BCC0613CE
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 09:52:59 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id f19so265797pfj.11
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 09:52:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Yw8E0ulWVQlaL8BcUt/yjwge7L71Y/eTIrTpA11Zcik=;
        b=Ozqj0QKhRLwCZUypzAhoMCYcqflkJW6uhB2cAhcv0S/w9rmhjiv/05CpffjWJE5iIA
         gX8UlsJq3LsksITCZGCtXLlFowsLrpi32LO3FGWSQo2EQnmzOFuSiv5+iAz6gRczSj+t
         BJ+Zm9pesLWVcE6z1JzNDE7erfaUXtntZQGIrovPS0COnXKCFk8hI8gDBi4f/vldSM1S
         xoWOUBiSbkuBnFx0z1eKUeQCFsHU3kxiFQKdZtQR+PI+i3jDKhRiYKRV5uRKgSlkkOTj
         QZBpycxVoWiEcaai4JCIqXBj7RUhltu5PcVx3j9vgYETSYw08qa6gH7rfsbYSwIeIOLN
         EtBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Yw8E0ulWVQlaL8BcUt/yjwge7L71Y/eTIrTpA11Zcik=;
        b=OE7mz7ZaRfl0jiyzwrdq/+U7SOnlLc/kz8a6SnCnMZZD8MkyYfzQT5Ob6uiBW5xrux
         Yr4V5c1Rx7d6cdjLZsssTmhfPFor6P7a0bSEZ9IDlmCfBaGQblDTBXS7ex3KeHHem/Dq
         ISkdrca7b7xw/TriHti7WAV3fyOnHP+bQv6eJv+Xb4Pwsr8FeQpbrwksVP8id0b3qJna
         /Bu4a9+de/UkHWAqs016NdgXpTsMATqFFSYFH0N/nN96/JjE+oLDE9yriDy0UNQL1tWe
         vVmo54B7EVSIITiD5Mbr4GCdtFpoT/vjb2NBTsA+MTeROWmUcJgUK0x50uk/VHyettn1
         ltPg==
X-Gm-Message-State: AOAM532I7ZjRCILkykFdwLGSCkEDOg7uM5WvyQ2K0iFCzDjQ72qoC5LM
        oHxj/SQQ7I6QfUn09JE2Zfs=
X-Google-Smtp-Source: ABdhPJyPbf6PgoB8x9yfETwZAocp/F3nmpXLKelzdxh5YAQKyCDP4I2zJJPWgsi6LTmosaQD5mITJw==
X-Received: by 2002:a63:1e65:: with SMTP id p37mr501773pgm.131.1603126378829;
        Mon, 19 Oct 2020 09:52:58 -0700 (PDT)
Received: from ?IPv6:2601:647:4700:9b2:c031:b044:ee25:f7b0? ([2601:647:4700:9b2:c031:b044:ee25:f7b0])
        by smtp.gmail.com with ESMTPSA id y126sm187984pgb.40.2020.10.19.09.52.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Oct 2020 09:52:58 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [kvm-unit-tests PATCHv2] unittests.cfg: Increase timeout for apic
 test
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <a6e33cd7d0084d6389a02786225db0e8@intel.com>
Date:   Mon, 19 Oct 2020 09:52:57 -0700
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C67F3473-32FE-4099-BBB1-8BB31B1ED95D@gmail.com>
References: <20201013091237.67132-1-po-hsu.lin@canonical.com>
 <87d01j5vk7.fsf@vitty.brq.redhat.com>
 <20201015163539.GA27813@linux.intel.com>
 <87o8ky4fkf.fsf@vitty.brq.redhat.com>
 <a6e33cd7d0084d6389a02786225db0e8@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Oct 19, 2020, at 9:37 AM, Christopherson, Sean J =
<sean.j.christopherson@intel.com> wrote:
>=20
> On Mon, Oct 19, 2020 at 01:32:00PM +0200, Vitaly Kuznetsov wrote:
>> Sean Christopherson <sean.j.christopherson@intel.com> writes:
>>> E.g. does running 1M loops in test_multiple_nmi() really add value =
versus
>>> say 10k or 100k loops?
>>=20
>> Oddly enough, I vaguely remember this particular test hanging
>> *sometimes* after a few thousand loops but I don't remember any
>> details.
>=20
> Thousands still ain't millions :-D.
>=20
> IMO, the unit tests should sit between a smoke test and a long =
running,
> intensive stress test, i.e. the default config shouldn't be trying to =
find
> literal one-in-a-million bugs on every run.

IIRC, this test failed on VMware, and according to our previous =
discussions,
does not follow the SDM as NMIs might be collapsed [1].

[1] https://marc.info/?l=3Dkvm&m=3D145876994031502&w=3D2

