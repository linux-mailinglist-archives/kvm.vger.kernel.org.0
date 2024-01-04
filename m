Return-Path: <kvm+bounces-5643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 42A4E82414E
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 13:10:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9B361B22EA0
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 12:10:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA76821376;
	Thu,  4 Jan 2024 12:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="OMS+MlJD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27AC21352
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 12:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1d3eae5c1d7so2631995ad.2
        for <kvm@vger.kernel.org>; Thu, 04 Jan 2024 04:10:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1704370243; x=1704975043; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q23i9yT7yrVEFxnf3fk5D4MyK0KHTuKJKDM3rop1kno=;
        b=OMS+MlJD7oTp11SRA0ChYf8ILqLyu/T2TOFFtV1qcj6FQnRUWUgiU2osG+ZggmLOOt
         flZcIGaESGBuN2TSI9V5QrEqUQWlHXfdAg7wW0tiBGCwMIFYB1lAXGePkrfSdbBAeVjm
         H2N7I/3eLJNyZeVZQ/n4Ayt7IiFtVE8Pjn3BxjUS7jH5BeAMhLoAgoJhedhNQpGCGLbs
         VQU+79tzS/L3rHzEA0m6HAcRE8kjOLjeVZCO4C6wyunoZm3NhBW2DO251QcUAQJQLUpF
         eLt2RcTpND7MfigiikNbmabCUkKSwm2U+gghg3Il98PJ6bT4x2pkNbz6o3OmqhoaEZTp
         lslg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704370243; x=1704975043;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q23i9yT7yrVEFxnf3fk5D4MyK0KHTuKJKDM3rop1kno=;
        b=pc1WJXfVAXoShEZkrAXHYKYMhQhcsLTe674hEIiV0vVvgZPY0d2cV4SMALkT3qIwni
         sqlqSqxhh+lEVxx8a/KgCSfD+nmjhM91526uxTEColkxQxdvNJZAfbOkZV9ehhXYzfKC
         2Qx9aeArrYXAYGSMpdbfSlMJmro/SfWK8zh+idN1wtwBjbKUTDbT1duLaoEflmgO4bs/
         fqOksLNqnvDgsyZu4df9fwRUXvrsDUW97pLQD+D6fTV1vANqjsFDStzgkhMBtnoK0P92
         FppebGSYsCjaeUbQfGGe1OUSXFOdjiqKF1862Ej69q6wDN9m6xhKSocj0dpksE843byl
         dPvA==
X-Gm-Message-State: AOJu0YwUdnvkQe1IL6Vjrhf+4G3yB2uUHuxH9pQxup/ZdDxoYkk0Cxmh
	qMPrxNW4yehzqMPNUW+tWV4d31dw3D1R0A==
X-Google-Smtp-Source: AGHT+IEvVniyWW6+pm7fNDiUCukxNFVRQmngQJsY2M7PnvRddXZwN4RLgEaC/QIRqiAw2JDtmofBpQ==
X-Received: by 2002:a17:903:1d1:b0:1d4:2b5a:9cb7 with SMTP id e17-20020a17090301d100b001d42b5a9cb7mr365235plh.47.1704370243101;
        Thu, 04 Jan 2024 04:10:43 -0800 (PST)
Received: from ?IPV6:2400:4050:a840:1e00:9ac7:6d57:2b16:6932? ([2400:4050:a840:1e00:9ac7:6d57:2b16:6932])
        by smtp.gmail.com with ESMTPSA id x22-20020a170902821600b001cfc1b931a9sm25324308pln.249.2024.01.04.04.10.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jan 2024 04:10:42 -0800 (PST)
Message-ID: <480302ec-4fb2-4e97-8940-8ec27846efc5@daynix.com>
Date: Thu, 4 Jan 2024 21:10:26 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/5] Make Big QEMU Lock naming consistent
Content-Language: en-US
To: Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org
Cc: Hanna Reitz <hreitz@redhat.com>, qemu-riscv@nongnu.org,
 Roman Bolshakov <rbolshakov@ddn.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@kaod.org>, Elena Ufimtseva <elena.ufimtseva@oracle.com>,
 Eduardo Habkost <eduardo@habkost.net>, Thomas Huth <thuth@redhat.com>,
 qemu-block@nongnu.org, Andrey Smirnov <andrew.smirnov@gmail.com>,
 Peter Maydell <peter.maydell@linaro.org>, Huacai Chen
 <chenhuacai@kernel.org>, Fam Zheng <fam@euphon.net>,
 Gerd Hoffmann <kraxel@redhat.com>, David Gibson
 <david@gibson.dropbear.id.au>, John Snow <jsnow@redhat.com>,
 Stafford Horne <shorne@gmail.com>, Weiwei Li <liwei1518@gmail.com>,
 Jean-Christophe Dubois <jcd@tribudubois.net>,
 Cameron Esfahani <dirty@apple.com>, Alexander Graf <agraf@csgraf.de>,
 David Hildenbrand <david@redhat.com>, Juan Quintela <quintela@redhat.com>,
 Nicholas Piggin <npiggin@gmail.com>, Max Filippov <jcmvbkbc@gmail.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Markus Armbruster <armbru@redhat.com>, Peter Xu <peterx@redhat.com>,
 Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
 Richard Henderson <richard.henderson@linaro.org>, qemu-s390x@nongnu.org,
 Jiri Slaby <jslaby@suse.cz>, Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>,
 Eric Blake <eblake@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Jiaxun Yang <jiaxun.yang@flygoat.com>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 Alistair Francis <alistair.francis@wdc.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Fabiano Rosas <farosas@suse.de>, Michael Roth <michael.roth@amd.com>,
 Paul Durrant <paul@xen.org>, Jagannathan Raman <jag.raman@oracle.com>,
 Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Hyman Huang <yong.huang@smartx.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 xen-devel@lists.xenproject.org, Halil Pasic <pasic@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Song Gao <gaosong@loongson.cn>, Kevin Wolf <kwolf@redhat.com>,
 Ilya Leoshkevich <iii@linux.ibm.com>, Artyom Tarasenko
 <atar4qemu@gmail.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Reinoud Zandijk <reinoud@netbsd.org>, qemu-ppc@nongnu.org,
 Marcelo Tosatti <mtosatti@redhat.com>, David Woodhouse
 <dwmw2@infradead.org>, Aurelien Jarno <aurelien@aurel32.net>,
 Bin Meng <bin.meng@windriver.com>, qemu-arm@nongnu.org,
 Anthony Perard <anthony.perard@citrix.com>,
 Leonardo Bras <leobras@redhat.com>,
 Hailiang Zhang <zhanghailiang@xfusion.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, kvm@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, Eric Farman <farman@linux.ibm.com>,
 BALATON Zoltan <balaton@eik.bme.hu>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>
References: <20240102153529.486531-1-stefanha@redhat.com>
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <20240102153529.486531-1-stefanha@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/01/03 0:35, Stefan Hajnoczi wrote:
> v3:
> - Rebase
> - Define bql_lock() macro on a single line [Akihiko Odaki]
> v2:
> - Rename APIs bql_*() [PeterX]
> - Spell out "Big QEMU Lock (BQL)" in doc comments [PeterX]
> - Rename "iolock" variables in hw/remote/mpqemu-link.c [Harsh]
> - Fix bql_auto_lock() indentation in Patch 2 [Ilya]
> - "with BQL taken" -> "with the BQL taken" [Philippe]
> - "under BQL" -> "under the BQL" [Philippe]
> 
> The Big QEMU Lock ("BQL") has two other names: "iothread lock" and "QEMU global
> mutex". The term "iothread lock" is easily confused with the unrelated --object
> iothread (iothread.c).
> 
> This series updates the code and documentation to consistently use "BQL". This
> makes the code easier to understand.

For the whole series,
Reviewed-by: Akihiko Odaki <akihiko.odaki@daynix.com>

Thank you for sorting this out.

