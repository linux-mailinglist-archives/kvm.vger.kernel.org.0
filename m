Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6173203B4
	for <lists+kvm@lfdr.de>; Sat, 20 Feb 2021 05:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhBTE5P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Feb 2021 23:57:15 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:49069 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229796AbhBTE5O (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Feb 2021 23:57:14 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 5B1695801E0;
        Fri, 19 Feb 2021 23:56:28 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 19 Feb 2021 23:56:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        subject:to:cc:references:from:message-id:date:mime-version
        :in-reply-to:content-type:content-transfer-encoding; s=fm1; bh=e
        w4rDXFjORrnaWrT8n3uqrMPpim/bERyTZjTNj0SfKk=; b=fpQ7FPVVjOMFE2yyE
        FNUHElK4nO+SsoStVcmw2jrZ5Cv6CnWTxyKPxmXSaWVBfwMgqODMOdaim2pC8Tj5
        bea65b6rCacpd8di7gUjpnrtGF0f6Xu3hV13MLmUh1qOmTRNomo9II+FD/h1fNB+
        TGjAs68E5I48WnbX3UIari3ihJSOXJwkBBzrhBLB+HDdc1qIT0edUXMQIYU2/PGJ
        mLr+k26ig8OYTGuxdNemeee1IK7ytclbzI0K98DIm2VVpMrmCyDywI++HbMWFXGB
        7iuIxGkEWQK/+X+j7McK3Jjis9VtO8tKU+EwyDekbnWwXrTidGdHPrz5YrRZ6wcE
        +zUcw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=ew4rDXFjORrnaWrT8n3uqrMPpim/bERyTZjTNj0Sf
        Kk=; b=lNK+rhEYZErGTX9nit6VPNlLS2v36eJDuJAuHh48yOSDiwaE3YLU3mTCH
        MrLmY3BTsvGSP+imDek+7/H+C6OGJOIU1EJ/z2QbDCqD5xnir0u1xVCx6sAFJJLh
        y/Sm7Va9nufReSeTVUrPmrgV7PGnxUlNWEA3OlWwhiwJMtXNp+cy1WksjN0czqQi
        rIVeF6Ohy5sM/sIdW4VQqJdJ7L+VEHhfMd1mDTSZiD750su6mceeMfhKJ8RevtK8
        ckYbyroxUhQTzPOrzO4tM0Dn1ECOMukvlktd6/bpSUpy4IdGdaarNW+x2zsa+ch8
        5KAbhmc8QZ5F00h9pLCQ5l3Oz1MuA==
X-ME-Sender: <xms:eZYwYNOR8DaRvfsFr8rkPxdYgd-sqXZDxq5odzG3dGwR6vEpt6Ufqg>
    <xme:eZYwYP_E6zehce78SHXjPq5GxLB75qESQY4t6rBmqVgLrsKIL-V7VS-OkHXo1N0wF
    6gnjjR4qklvJC7OaJc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrjeejgdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefuvfhfhffkffgfgggjtgfgsehtkeertddtfeejnecuhfhrohhmpeflihgrgihu
    nhcujggrnhhguceojhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomheqnecugg
    ftrfgrthhtvghrnhepiefhgffhieekudegjeevgfffveegveegheffhfduieeiffffveff
    ueegveefgfefnecukfhppeduheegrddujedruddvrdelkeenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehjihgrgihunhdrhigrnhhgsehflhih
    ghhorghtrdgtohhm
X-ME-Proxy: <xmx:eZYwYMRS1FaafIy7kzIqXLqP9wse2X4c80nO6pMVNIFguXxmIIsKwA>
    <xmx:eZYwYJvBVkTBcgWQ9qo66EYJNuZN5f8bBYTPJcB0swHlWQjAsrToOw>
    <xmx:eZYwYFd1CSyNlgilrdhHr74lnkGmxB_W7nE96O168sKphP6WYJ_d7Q>
    <xmx:fJYwYEbSY6qPa6Bpsmq4jrxD4EeFhtbHxd6bVB2lE5PcvHiEH56H0w>
Received: from [0.0.0.0] (unknown [154.17.12.98])
        by mail.messagingengine.com (Postfix) with ESMTPA id 537B9240057;
        Fri, 19 Feb 2021 23:56:15 -0500 (EST)
Subject: Re: [PATCH v2 05/11] hw/mips: Restrict KVM to the malta & virt
 machines
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Peter Maydell <peter.maydell@linaro.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-ppc@nongnu.org, qemu-s390x@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        xen-devel@lists.xenproject.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        qemu-arm@nongnu.org, Stefano Stabellini <sstabellini@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Leif Lindholm <leif@nuviainc.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Radoslaw Biernacki <rad@semihalf.com>,
        Alistair Francis <alistair@alistair23.me>,
        Paul Durrant <paul@xen.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?Q?Herv=c3=a9_Poussineau?= <hpoussin@reactos.org>,
        Greg Kurz <groug@kaod.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
References: <20210219173847.2054123-1-philmd@redhat.com>
 <20210219173847.2054123-6-philmd@redhat.com>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-ID: <31a32613-2a61-7cd2-582a-4e6d10949436@flygoat.com>
Date:   Sat, 20 Feb 2021 12:56:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210219173847.2054123-6-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

在 2021/2/20 上午1:38, Philippe Mathieu-Daudé 写道:
> Restrit KVM to the following MIPS machines:
> - malta
> - loongson3-virt
>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>

Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>

> ---
>   hw/mips/loongson3_virt.c | 5 +++++
>   hw/mips/malta.c          | 5 +++++
>   2 files changed, 10 insertions(+)
>
> diff --git a/hw/mips/loongson3_virt.c b/hw/mips/loongson3_virt.c
> index d4a82fa5367..c3679dff043 100644
> --- a/hw/mips/loongson3_virt.c
> +++ b/hw/mips/loongson3_virt.c
> @@ -612,6 +612,10 @@ static void mips_loongson3_virt_init(MachineState *machine)
>       loongson3_virt_devices_init(machine, liointc);
>   }
>   
> +static const char *const valid_accels[] = {
> +    "tcg", "kvm", NULL
> +};
> +
>   static void loongson3v_machine_class_init(ObjectClass *oc, void *data)
>   {
>       MachineClass *mc = MACHINE_CLASS(oc);
> @@ -622,6 +626,7 @@ static void loongson3v_machine_class_init(ObjectClass *oc, void *data)
>       mc->max_cpus = LOONGSON_MAX_VCPUS;
>       mc->default_ram_id = "loongson3.highram";
>       mc->default_ram_size = 1600 * MiB;
> +    mc->valid_accelerators = valid_accels;
>       mc->kvm_type = mips_kvm_type;
>       mc->minimum_page_bits = 14;
>   }
> diff --git a/hw/mips/malta.c b/hw/mips/malta.c
> index 9afc0b427bf..0212048dc63 100644
> --- a/hw/mips/malta.c
> +++ b/hw/mips/malta.c
> @@ -1443,6 +1443,10 @@ static const TypeInfo mips_malta_device = {
>       .instance_init = mips_malta_instance_init,
>   };
>   
> +static const char *const valid_accels[] = {
> +    "tcg", "kvm", NULL
> +};
> +
>   static void mips_malta_machine_init(MachineClass *mc)
>   {
>       mc->desc = "MIPS Malta Core LV";
> @@ -1456,6 +1460,7 @@ static void mips_malta_machine_init(MachineClass *mc)
>       mc->default_cpu_type = MIPS_CPU_TYPE_NAME("24Kf");
>   #endif
>       mc->default_ram_id = "mips_malta.ram";
> +    mc->valid_accelerators = valid_accels;
>   }
>   
>   DEFINE_MACHINE("malta", mips_malta_machine_init)

