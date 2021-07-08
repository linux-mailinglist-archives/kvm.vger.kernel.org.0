Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D877C3C16EA
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 18:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbhGHQQn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jul 2021 12:16:43 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:60289 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229554AbhGHQQn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Jul 2021 12:16:43 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id BB3AB1940BBC;
        Thu,  8 Jul 2021 12:14:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 08 Jul 2021 12:14:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Y9L7mn
        PoCTM9eva9Nk3xNyfoePPSqUmsc1qRlRIrQdw=; b=WOCOEfVpAWhAx9OzZN72Gr
        yovqrAcfKcov4l0h4AYdb9AA0KufNz7Kf2PgRAdW+FeiWN17Bhg4Rdzr+ON4rxmd
        daS92GV3K4+3UX8QrLOtwAUkJegbir7Hub6diKYCDYADaSUnZEUuUYqHWJkjKu2y
        wCRTlpVmKb4OxF9Vo3fhDkG9rnYmtlBBHkfeSPvFNuBtudg/DlW6nGlhjzd7WU4R
        jJX9UowEKhixIdmB0/UDpICZfjzNlGt+CiRfeZ278zXDQ0FI7A4VB6FsD76aNHiE
        01yA2k1PE1jHP+Tw52V0INtX/DVua7440LXLio8ZqiLDh5lUtmarG/q0aVpk201A
        ==
X-ME-Sender: <xms:SCTnYMtY5AzJIlFAWXtfT4E846YOH103Hxc-jdBu-ceF4WFR72u2lA>
    <xme:SCTnYJdMGtIfrd7BTpEcHYPTa3XYna7CUsZpA3BFjOPV_enbMfs9sYfuI49Od-LF2
    0Smp1RXLRzgNq9zV98>
X-ME-Received: <xmr:SCTnYHyelpq2n9mUp7X-hYtGIX0MrMz8A9MIomodABj7hMwGWnZlfIByZDk61PFqwCaRgXeXujQRqwK5Cj0O8kXcFkWNm8JCOv9BDuRGo24>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrtdeggdeliecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefvufgjfhfhfffkgggtsehttdertddttddtnecuhfhrohhmpeffrghvihguucfg
    ughmohhnughsohhnuceoughmvgesughmvgdrohhrgheqnecuggftrfgrthhtvghrnhephf
    ekgeeutddvgeffffetheejvdejieetgfefgfffudegffffgeduheegteegleeknecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepughmvgesughmvg
    drohhrgh
X-ME-Proxy: <xmx:SCTnYPNOuAtliKVlWttL8H5HwkoPTIp643iCdF383l78HDfFOykn_w>
    <xmx:SCTnYM-zr1K0HIy_V_8S0gV80I3Z-D1JjqRA5-_lzcdqi10lQFpM4Q>
    <xmx:SCTnYHUlFtahG1P2u-7yHV_bFCOLMWRCdTL7MHNkbFrRMjRBcHrZHQ>
    <xmx:SCTnYN3XNggwSSy19oheJovx5ocYSvSA-AsL6n5VXe1bAP2ZZ2olgA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 8 Jul 2021 12:13:59 -0400 (EDT)
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 6ef51eab;
        Thu, 8 Jul 2021 16:13:57 +0000 (UTC)
To:     Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Michael Roth <michael.roth@amd.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Cameron Esfahani <dirty@apple.com>, babu.moger@amd.com,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 8/8] target/i386: Move X86XSaveArea into TCG
In-Reply-To: <e4a048f5-cc6d-7bbe-6659-54075cafb9c6@linaro.org>
References: <20210705104632.2902400-1-david.edmondson@oracle.com>
 <20210705104632.2902400-9-david.edmondson@oracle.com>
 <0d75c3ab-926b-d4cd-244a-8c8b603535f9@linaro.org> <m2czru4epe.fsf@dme.org>
 <m24kd5p7uf.fsf@dme.org> <e4a048f5-cc6d-7bbe-6659-54075cafb9c6@linaro.org>
X-HGTTG: heart-of-gold
From:   David Edmondson <dme@dme.org>
Date:   Thu, 08 Jul 2021 17:13:57 +0100
Message-ID: <m235so4wca.fsf@dme.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday, 2021-07-08 at 08:22:02 -07, Richard Henderson wrote:

> On 7/8/21 12:45 AM, David Edmondson wrote:
>> Actually, that's nonsense. With KVM or HVF we have to use the offsets of
>> the host CPU, as the hardware won't do anything else, irrespective of
>> the general CPU model chosen.
>> 
>> To have KVM -> TCG migration work it would be necessary to pass the
>> offsets in the migration stream and have TCG observe them, as you
>> originally said.
>> 
>> TCG -> KVM migration would only be possible if TCG was configured to use
>> the same offsets as would later required by KVM (meaning, the host CPU).
>
> And kvm -> kvm migration, with the same general cpu model chosen, but with different host 
> cpus with different offsets?
>
> It seems like we must migrate then and verify the offsets in that case, so that we can 
> fail the migration.

Agreed.

I will look into migrating the offsets.

dme.
-- 
The sound of a barking dog on a loop, a plane rises in the crystal blue.
