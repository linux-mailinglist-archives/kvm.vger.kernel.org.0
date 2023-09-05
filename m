Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7042793096
	for <lists+kvm@lfdr.de>; Tue,  5 Sep 2023 23:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234020AbjIEVDo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 17:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjIEVDm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 17:03:42 -0400
Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3B29F
        for <kvm@vger.kernel.org>; Tue,  5 Sep 2023 14:03:38 -0700 (PDT)
Date:   Tue, 05 Sep 2023 21:02:56 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail3; t=1693947800; x=1694207000;
        bh=lnU3jP6XRIB05J62YojNOLIAL72jryY/yVaVoJ9LLXU=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=t+u4l6KzF7c3NXQ3gUu8LpPeVHwgr0ZMcqWNDUVXn8MRBDamEG5kBJmmfWGCqtBy5
         Lz6Gl9rMNFMfT77eWCL6VnDeVcdY7iRkPzAFfLR3iNTVq3HoPXM45tJDFevV1Atyrc
         DX7PJjwVZU/VQWyfs3LBYpsVOAiM0D+VuRSo8vuwV9bFzhR43zukRB4vT3VlBStMUL
         53uIIMOBKPo5pKf4HGvYClqsE8GmcF/zjstOkHH3faKSzUUjA71RdotQlA+D9bYoly
         W2PcakX9Ci73vKJvcFxpOwZuGcF6dOZK8frkVb2i4MtWLEc0+t8zqKGyPWWFSYjdVu
         JS/LA+w7i1Hiw==
To:     Sean Christopherson <seanjc@google.com>
From:   Jari Ruusu <jariruusu@protonmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] kvm ignores ignore_msrs=1 VETO for some MSRs
Message-ID: <9QfRip7kvDo8diBjc9vXkIG9wHLO1PozwKVkFODPJNjfuE_FmzVU5beld8zj2P6V_honJWTo5j7tXIXRsrE5OtmPWdzcimhHYm-PQS7gn3Q=@protonmail.com>
In-Reply-To: <ZPeV1GWQWeH48a2G@google.com>
References: <NOTSPohUo5EZSaOrRTX88K-vU9QJqeV2Vqti75bEwTpckXBiudKyWw97EDAbgp9ODnk8-lCVBVNCYdd7YygWY5S2n-Yoz_BiJ13DeNLEItI=@protonmail.com> <ZPeBE5aZqLwdnspl@google.com> <DSxaeYtslZW13dZU36PVY2RooaqU99qcXgPSYkyw6F5t8LSJk8MkAn1shTVrb-cAFRaKEVr5VDrWD6JRmSTlpDbGrHBiM-8zHwIiH90nNHI=@protonmail.com> <ZPeV1GWQWeH48a2G@google.com>
Feedback-ID: 22639318:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tuesday, September 5th, 2023 at 23:55, Sean Christopherson <seanjc@googl=
e.com> wrote:
> On Tue, Sep 05, 2023, Jari Ruusu wrote:
> > Newer host kernels seem to have kvm.enable_pmu parameter,
> > but linux-5.10.y kernels do not have that.
>=20
> Gah, try kvm.pmu.

No kvm.pmu parameter in linux-5.10.y either.

--
Jari Ruusu=C2=A0 4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD=C2=A0 ACDF F073 3C=
80 8132 F189

