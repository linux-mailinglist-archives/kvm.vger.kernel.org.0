Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3641232187F
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 14:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbhBVNWf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 08:22:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42005 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231783AbhBVNUw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 08:20:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613999959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qug2RTu/T1uSQ745n8lC2c0QqoReD0ieGgc66jNB2QI=;
        b=ZXK2bU/hAI145nE0kSYsrhyWKJqvPrfAC3IP04Sr4UFcUXFqizlFhxJAVZkm55EdU1Nbwg
        93bbDFoYR/qHwM2YyruFSnxJjaSa9ekz/7O6MnJdDE4eQU2V+1JbLeAkK8r01nO3L3EO6w
        aHU4bPcWGAYH3d5jrrVMheo7u6Onkng=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-wAiKIOFwNpePZGO0ILkmYA-1; Mon, 22 Feb 2021 08:19:17 -0500
X-MC-Unique: wAiKIOFwNpePZGO0ILkmYA-1
Received: by mail-ej1-f70.google.com with SMTP id mm18so1131293ejb.7
        for <kvm@vger.kernel.org>; Mon, 22 Feb 2021 05:19:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Qug2RTu/T1uSQ745n8lC2c0QqoReD0ieGgc66jNB2QI=;
        b=B8zBKbGfv61xraRANg1euBZTaZOXY/DnMkyOgTcRTDa02kiXTPBYHEn2bBaxgto93r
         F205FX5xCU90JkDcmZ5e7bKe9yQBjm3yIlvNxJD/3xn/098vm31Br1fjAibmPE7tvF2M
         YPjzsKVdEkXrx588ci5AEiGv2RkGqiYUnsmkGAvFBqTFgcp4eiNWjzXT5A75sngJQ+e+
         M6KVlzmVAaIDybQyojhR5kW3mqDTm1NtMxOa8p454E5nxYTQ4t6hIpsrNqObM9tRN7UW
         iTfGpaKHDM/7u8yeo3cvI7hvVvj+yz46G4Ra/pSxOfmpODWGLghMREtcM/yWI+ykjWkI
         pr1g==
X-Gm-Message-State: AOAM530zanM412GpZ503HP5sD1emsdpRK6qjEsTMV+0aRMsVYS91EBRk
        QxgNv6PJrWC5/2E5UaFmr/wpj9CcZvb6IUBK+Ln/QiSTVqknRzYVBgrjxcWEFd+QKC2OB5AF/Sv
        5eIvxkbAp0fhz
X-Received: by 2002:a17:906:cf8f:: with SMTP id um15mr5937377ejb.455.1613999956674;
        Mon, 22 Feb 2021 05:19:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwvbw/PgfA0F/25nHKxn/HTOW5jX2GdrY67Z+Yez2DT22kLFPNtBmQLRjUdkVjUL1EidwLbmg==
X-Received: by 2002:a17:906:cf8f:: with SMTP id um15mr5937362ejb.455.1613999956555;
        Mon, 22 Feb 2021 05:19:16 -0800 (PST)
Received: from [192.168.1.36] (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id kd13sm6734645ejc.106.2021.02.22.05.19.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Feb 2021 05:19:15 -0800 (PST)
Subject: Re: [RFC PATCH v2 06/11] hw/ppc: Restrict KVM to various PPC machines
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     qemu-devel@nongnu.org, Aurelien Jarno <aurelien@aurel32.net>,
        Peter Maydell <peter.maydell@linaro.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-ppc@nongnu.org, qemu-s390x@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        xen-devel@lists.xenproject.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
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
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
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
 <20210219173847.2054123-7-philmd@redhat.com>
 <YDNIQiHG0nfKXNR8@yekko.fritz.box>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <e28dc7fe-3a78-6b24-0034-830909f71f8e@redhat.com>
Date:   Mon, 22 Feb 2021 14:19:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YDNIQiHG0nfKXNR8@yekko.fritz.box>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/22/21 6:59 AM, David Gibson wrote:
> On Fri, Feb 19, 2021 at 06:38:42PM +0100, Philippe Mathieu-Daudé wrote:
>> Restrit KVM to the following PPC machines:
>> - 40p
>> - bamboo
>> - g3beige
>> - mac99
>> - mpc8544ds
>> - ppce500
>> - pseries
>> - sam460ex
>> - virtex-ml507
> 
> Hrm.
> 
> The reason this list is kind of surprising is because there are 3
> different "flavours" of KVM on ppc: KVM HV ("pseries" only), KVM PR
> (almost any combination, theoretically, but kind of buggy in
> practice), and the Book E specific KVM (Book-E systems with HV
> extensions only).
> 
> But basically, qemu explicitly managing what accelerators are
> available for each machine seems the wrong way around to me.  The
> approach we've generally taken is that qemu requests the specific
> features it needs of KVM, and KVM tells us whether it can supply those
> or not (which may involve selecting between one of the several
> flavours).
> 
> That way we can extend KVM to cover more situations without needing
> corresponding changes in qemu every time.

OK thanks for the information. I'll wait the other patches
get reviewed (in particular the most important ones, 2 and
10) before respining including this information.

Regards,

Phil.

