Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13DFE39F0C7
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 10:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbhFHI0t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 04:26:49 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:48893 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230389AbhFHI0s (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Jun 2021 04:26:48 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id B4B6A1940B71;
        Tue,  8 Jun 2021 04:24:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 08 Jun 2021 04:24:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=RPzD0z
        GkXpfv553M+YONMbFhNyYG7leqGwNEwjHbjZ8=; b=MgIaM5JNFXfjGr8f2cFNII
        HcqK6A02BUJjN/EEckK1Zv9Qi6N8dJyLPQaj/IbOhU8KOnmBhot08ju6otHbVD8a
        Fr4BOTUjIO4iy88WG9o630wN9Ws6SDdBhduuS8KsUOObHVN1C4oQV5Qh+YqueS/K
        A974i+cJJqZLaJclvc4GwMxw9FhtSBLnKkwq7I67g/r7DINtlolcXm0UDZoOTLXU
        KhpyY1DxuEram/G0j5VCGiH0a9ZLPat7EEVvaoi19mKUL9JHzTUu86MdPyBmTm0h
        yFPJ7A5woQt22hV4Qd6Bg2GDCuVAodVLueykQUIPNe6ssAGkQahSBhB9eGn/cCoQ
        ==
X-ME-Sender: <xms:Vym_YFUKXKtqCCjwjgoFpl6GvVBr0te8cyJ8-7TPGegO69O4q_BnwQ>
    <xme:Vym_YFngyiufQtdh3VavlEjgwI-Z5txfA5Uz64HPXDD6Rtepw4_6FNZD0KX63doxQ
    3VLRovSNTmTqKYNpE0>
X-ME-Received: <xmr:Vym_YBbUXeJGlh8LPVioO9hAToBGEOHSC-6Ql0MXaSC4X03FtXqLDM-5e9aXunHnCQVCZt81Z6YXArbSVNKmH8G04VrY63Z90ZKgOvaFKMI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtlecutefuodetggdotefrodftvfcurf
    hrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefvufgjfhfhfffkgggtsehttdertddttddtnecuhfhrohhmpeffrghvihguucfgughm
    ohhnughsohhnuceoughmvgesughmvgdrohhrgheqnecuggftrfgrthhtvghrnhephfekge
    eutddvgeffffetheejvdejieetgfefgfffudegffffgeduheegteegleeknecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepughmvgesughmvgdroh
    hrgh
X-ME-Proxy: <xmx:Vym_YIV9qotKi74hidaSxooZMCjV3wRPWanewf_IWU_k-FRyaKF19Q>
    <xmx:Vym_YPmzPO0EBcRc23Zgl1SUl5VLfGuimUIBe2n5f7n2TszCAeY4GA>
    <xmx:Vym_YFfz_OQvTSUGgPdKX3qdyhVB2gCh_G9miedxmJkQaftvfheUjA>
    <xmx:Vym_YNUyAa---q_M_cIoxc23UpcEZ4l-2vIZzEqezESL7BgtiaXHhw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 04:24:54 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id e21d0e6c;
        Tue, 8 Jun 2021 08:24:53 +0000 (UTC)
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Babu Moger <babu.moger@amd.com>
Subject: Re: [RFC PATCH 0/7] Support protection keys in an AMD EPYC-Milan VM
In-Reply-To: <20210520145647.3483809-1-david.edmondson@oracle.com>
References: <20210520145647.3483809-1-david.edmondson@oracle.com>
X-HGTTG: zarquon
From:   David Edmondson <dme@dme.org>
Date:   Tue, 08 Jun 2021 09:24:52 +0100
Message-ID: <cunpmww227f.fsf@dme.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday, 2021-05-20 at 15:56:40 +01, David Edmondson wrote:

> AMD EPYC-Milan CPUs introduced support for protection keys, previously
> available only with Intel CPUs.
>
> AMD chose to place the XSAVE state component for the protection keys
> at a different offset in the XSAVE state area than that chosen by
> Intel.
>
> To accommodate this, modify QEMU to behave appropriately on AMD
> systems, allowing a VM to properly take advantage of the new feature.
>
> Further, avoid manipulating XSAVE state components that are not
> present on AMD systems.
>
> The code in patch 6 that changes the CPUID 0x0d leaf is mostly dumped
> somewhere that seemed to work - I'm not sure where it really belongs.

Ping - any thoughts about this approach?

> David Edmondson (7):
>   target/i386: Declare constants for XSAVE offsets
>   target/i386: Use constants for XSAVE offsets
>   target/i386: Clarify the padding requirements of X86XSaveArea
>   target/i386: Prepare for per-vendor X86XSaveArea layout
>   target/i386: Introduce AMD X86XSaveArea sub-union
>   target/i386: Adjust AMD XSAVE PKRU area offset in CPUID leaf 0xd
>   target/i386: Manipulate only AMD XSAVE state on AMD
>
>  target/i386/cpu.c            | 19 +++++----
>  target/i386/cpu.h            | 80 ++++++++++++++++++++++++++++--------
>  target/i386/kvm/kvm.c        | 57 +++++++++----------------
>  target/i386/tcg/fpu_helper.c | 20 ++++++---
>  target/i386/xsave_helper.c   | 70 +++++++++++++++++++------------
>  5 files changed, 152 insertions(+), 94 deletions(-)
>
> -- 
> 2.30.2

dme.
-- 
You know your green from your red.
