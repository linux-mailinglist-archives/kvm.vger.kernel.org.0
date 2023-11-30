Return-Path: <kvm+bounces-2860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 64BD57FEB56
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 10:04:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E7ABBB210A4
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 09:04:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C9C7347B0;
	Thu, 30 Nov 2023 09:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JjEO02Qj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C8D1711
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 01:04:07 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-54b89582efeso644464a12.0
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 01:04:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701335046; x=1701939846; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rDG0LfrN9KzuY1dutbAJHJsyvk/SVEQtsaapgDeTQgk=;
        b=JjEO02QjZ6W+PeMl2r3ywAbyashTnJNpfSfZJv5+sLUYO5LUoJxqy0JMFBCd1tLRCt
         L2H/sNHOsRemLoKTd5iZYGfGitsDbDqwcc6EGeJrag6CHDNsrhGbvClYWFguNMw9sr9q
         yfqyqaDlVh82YIECvN/X8WlQReTbmg0U7U/czaZ1C9/ACtRVJVgo+Nz53XfKF+dwwyUm
         d+2MN6hqf9qGaIY2W8YSDQYTC4Dwcr5grpEXOtr3a+ndi1Nv/xN1CiQrXTlvGzfxDUO2
         GQssUrIcD7zByNm3zlHVP5L/Ud2XdCvBAnO+sdPOFLXq+JjAEcOLLLU8H+4GfjPjdIxc
         faVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701335046; x=1701939846;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rDG0LfrN9KzuY1dutbAJHJsyvk/SVEQtsaapgDeTQgk=;
        b=MMmfOhbBbvFTXnX9bIvLC77QpGM3z53GiYgZ7B9Gct0GAtX+Kn9HgG5h3uzu2+siIG
         qbQWMgvnAu6X+jorXIeeDlp4/uBqDVdWofKFpwmVn1G3r5Dxsw/leMqMqEBtlq7r/YG6
         YQW8fX1lCtIvtWrLGlciukLz8DEJ9sUjWwmHkXksfs6atLiYeD8Tn6LZ6fpDljvUjM2L
         A88ADiQ2OpD8TGZtvSOsIU7rwRI8ovZHmKiLt7JjWm+yXpiSjssIW35eiVonZ3d5w6C0
         zPuCFnB0uQ2QA83U8VZoEaqukatyCZAXSyniKWCp5A7bbdLF1cEC9Gs2QyQ5r2wY3na9
         kJrQ==
X-Gm-Message-State: AOJu0YxZn9KhvtUeioKI2ZXPpmasSkstQuh4G+YYnL3caUnP3chbS62Q
	otqeYcgjRMUrEwt+o0bOFbk=
X-Google-Smtp-Source: AGHT+IH62q365iHhXfNeCdgPZMilj33GjyyKhNs3sjPFImh+k7bvQx+U/QmZwntDvSzeLzApdBDisw==
X-Received: by 2002:a17:906:197:b0:a02:9987:dc3b with SMTP id 23-20020a170906019700b00a029987dc3bmr14284857ejb.15.1701335046283;
        Thu, 30 Nov 2023 01:04:06 -0800 (PST)
Received: from [192.168.17.21] (54-240-197-238.amazon.com. [54.240.197.238])
        by smtp.gmail.com with ESMTPSA id i16-20020a1709061cd000b009b2cc87b8c3sm438680ejh.52.2023.11.30.01.04.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Nov 2023 01:04:05 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <67642c0a-4c2d-4f0b-90e8-9b125647af6c@xen.org>
Date: Thu, 30 Nov 2023 09:03:58 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 2/6] qemu/main-loop: rename QEMU_IOTHREAD_LOCK_GUARD to
 QEMU_BQL_LOCK_GUARD
Content-Language: en-US
To: Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org
Cc: Jean-Christophe Dubois <jcd@tribudubois.net>,
 Fabiano Rosas <farosas@suse.de>, qemu-s390x@nongnu.org,
 Song Gao <gaosong@loongson.cn>, Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>, Thomas Huth <thuth@redhat.com>,
 Hyman Huang <yong.huang@smartx.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 David Woodhouse <dwmw2@infradead.org>,
 Andrey Smirnov <andrew.smirnov@gmail.com>,
 Peter Maydell <peter.maydell@linaro.org>, Kevin Wolf <kwolf@redhat.com>,
 Ilya Leoshkevich <iii@linux.ibm.com>, Artyom Tarasenko
 <atar4qemu@gmail.com>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
 Max Filippov <jcmvbkbc@gmail.com>,
 Alistair Francis <alistair.francis@wdc.com>,
 Jagannathan Raman <jag.raman@oracle.com>, Juan Quintela
 <quintela@redhat.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, qemu-arm@nongnu.org, Jason Wang
 <jasowang@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>,
 Hanna Reitz <hreitz@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 BALATON Zoltan <balaton@eik.bme.hu>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Elena Ufimtseva <elena.ufimtseva@oracle.com>,
 Aurelien Jarno <aurelien@aurel32.net>,
 Hailiang Zhang <zhanghailiang@xfusion.com>,
 Roman Bolshakov <rbolshakov@ddn.com>, Huacai Chen <chenhuacai@kernel.org>,
 Fam Zheng <fam@euphon.net>, Eric Blake <eblake@redhat.com>,
 Jiri Slaby <jslaby@suse.cz>, Alexander Graf <agraf@csgraf.de>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, Weiwei Li <liwei1518@gmail.com>,
 Eric Farman <farman@linux.ibm.com>, Stafford Horne <shorne@gmail.com>,
 David Hildenbrand <david@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Reinoud Zandijk <reinoud@netbsd.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Cameron Esfahani <dirty@apple.com>, xen-devel@lists.xenproject.org,
 Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>, qemu-riscv@nongnu.org,
 Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
 John Snow <jsnow@redhat.com>, Sunil Muthuswamy <sunilmut@microsoft.com>,
 Michael Roth <michael.roth@amd.com>,
 David Gibson <david@gibson.dropbear.id.au>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Bin Meng <bin.meng@windriver.com>,
 Stefano Stabellini <sstabellini@kernel.org>, kvm@vger.kernel.org,
 qemu-block@nongnu.org, Halil Pasic <pasic@linux.ibm.com>,
 Peter Xu <peterx@redhat.com>, Anthony Perard <anthony.perard@citrix.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>, Paolo Bonzini <pbonzini@redhat.com>,
 Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>, qemu-ppc@nongnu.org,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Akihiko Odaki <akihiko.odaki@daynix.com>, Leonardo Bras
 <leobras@redhat.com>, Nicholas Piggin <npiggin@gmail.com>,
 Jiaxun Yang <jiaxun.yang@flygoat.com>
References: <20231129212625.1051502-1-stefanha@redhat.com>
 <20231129212625.1051502-3-stefanha@redhat.com>
Organization: Xen Project
In-Reply-To: <20231129212625.1051502-3-stefanha@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29/11/2023 21:26, Stefan Hajnoczi wrote:
> The name "iothread" is overloaded. Use the term Big QEMU Lock (BQL)
> instead, it is already widely used and unambiguous.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>   include/qemu/main-loop.h  | 20 ++++++++++----------
>   hw/i386/kvm/xen_evtchn.c  | 14 +++++++-------
>   hw/i386/kvm/xen_gnttab.c  |  2 +-
>   hw/mips/mips_int.c        |  2 +-
>   hw/ppc/ppc.c              |  2 +-
>   target/i386/kvm/xen-emu.c |  2 +-
>   target/ppc/excp_helper.c  |  2 +-
>   target/ppc/helper_regs.c  |  2 +-
>   target/riscv/cpu_helper.c |  4 ++--
>   9 files changed, 25 insertions(+), 25 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>


