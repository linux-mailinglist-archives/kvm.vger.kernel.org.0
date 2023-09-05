Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A867B79302C
	for <lists+kvm@lfdr.de>; Tue,  5 Sep 2023 22:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236304AbjIEUmM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 16:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbjIEUmL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 16:42:11 -0400
Received: from mail-4318.protonmail.ch (mail-4318.protonmail.ch [185.70.43.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 172EED8
        for <kvm@vger.kernel.org>; Tue,  5 Sep 2023 13:42:08 -0700 (PDT)
Date:   Tue, 05 Sep 2023 20:41:55 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail3; t=1693946526; x=1694205726;
        bh=nMhBFoDbJTytPibQDxfsvKoYj5uooqxFgErW++G6iuk=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=mY3Oe9vOre8puaLJFdocm2PUS4Pk6fgqdVpkpCv3YfLyh8A2oV3cYDqVa2McvdEoA
         VvoQO2kVUWluH1gDTwPnQEL7kzC82QhcCJpk5anrGb4vT2rBiEHXr5GyxpzoHU0Ysd
         /DWDrvndw1XK/pSkWUbnnHN6Hg0SM/TDysT4ms/DTVTWULUBWMf7aDZODtnRrLVpSC
         G503EtB3CiWKyMQC6La7QVig2MsfWsNpcrije+Ef0re9kw5Bo09qV2B1MV/quJkmT7
         8KO8pmB2fSDOow1DjSQoN/Chej8tCIofAU0ShPsjzK70MIAH9kEzh2+jbny7hLGeoZ
         KFHEXT+mXsQqQ==
To:     Sean Christopherson <seanjc@google.com>
From:   Jari Ruusu <jariruusu@protonmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] kvm ignores ignore_msrs=1 VETO for some MSRs
Message-ID: <DSxaeYtslZW13dZU36PVY2RooaqU99qcXgPSYkyw6F5t8LSJk8MkAn1shTVrb-cAFRaKEVr5VDrWD6JRmSTlpDbGrHBiM-8zHwIiH90nNHI=@protonmail.com>
In-Reply-To: <ZPeBE5aZqLwdnspl@google.com>
References: <NOTSPohUo5EZSaOrRTX88K-vU9QJqeV2Vqti75bEwTpckXBiudKyWw97EDAbgp9ODnk8-lCVBVNCYdd7YygWY5S2n-Yoz_BiJ13DeNLEItI=@protonmail.com> <ZPeBE5aZqLwdnspl@google.com>
Feedback-ID: 22639318:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tuesday, September 5th, 2023 at 22:27, Sean Christopherson <seanjc@googl=
e.com> wrote:
> While this is arguably a regression, this isn't going to be addressed in =
KVM.

OK, I understand.

> As for working around this in your setup, assuming you don't actually nee=
d a
> virtual PMU in the guest, the simplest workaround would be to turn off vP=
MU
> support in KVM, i.e. boot with kvm.enable_pmu=3D0. That should cause QEMU=
 to not
> advertise a PMU to the guest.

Newer host kernels seem to have kvm.enable_pmu parameter,
but linux-5.10.y kernels do not have that.

> Alternatively, if supported by QEMU, you could try enumerating a version =
1
> vPMU to the guest.

That old version of Qemu does not seem to have that available.

I am perfectly OK patching my kernels with my quick-and-dirty fix until I
upgrade to newer kernel series.

Thank you for your reply. It clarified many things for me.

--
Jari Ruusu=C2=A0 4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD=C2=A0 ACDF F073 3C=
80 8132 F189

