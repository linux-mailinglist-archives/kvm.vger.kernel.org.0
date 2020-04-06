Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3839B19F15D
	for <lists+kvm@lfdr.de>; Mon,  6 Apr 2020 10:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgDFIOJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Apr 2020 04:14:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48359 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726491AbgDFIOJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Apr 2020 04:14:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586160847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r6MlahNDA6YdiNH2kfwRp2fNrq9jvaChBzjvW2e+WXM=;
        b=GvgzYIjnYBW3N6IGM9HLYyuZRHvotYteMfl7HJNCukivabM4IEZRLbrbu5WOs0KbwwAp3V
        l7r08ieUXhE7u9jsKXlb4C3y92EEhXGyA9jQfXe7gNK4TXdltuDDmGdAykU2A9S8CcTW3L
        YLMK04M2UKIlH/tAMlUsXfFkCz07WAo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-VhmeMKoDMYOPzVwFKTYz0Q-1; Mon, 06 Apr 2020 04:14:05 -0400
X-MC-Unique: VhmeMKoDMYOPzVwFKTYz0Q-1
Received: by mail-wr1-f72.google.com with SMTP id y1so7965756wrn.10
        for <kvm@vger.kernel.org>; Mon, 06 Apr 2020 01:14:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r6MlahNDA6YdiNH2kfwRp2fNrq9jvaChBzjvW2e+WXM=;
        b=WCzwUnBNeZNcXkUar80GgIC6FK7ElpRidYfg7GRVGSV3nBQYSklcKfOxUNP+XXiMOC
         Hjl6+OY04BNHz7XYPbXn9GBW1loG1ecwH9M3ePING9a10gejTss5XmzdqM3L8cbzZPK4
         a2IyCJoCoJq2IgY6H+2ktytfC9fYHqhgUsFuuoRFWVlUZvzmAojStFdWbpaA7rIufokq
         yCALIhurz67KeLOVXmZ4uNgA7ks/ifyavnLvvt3X8APXh+gvsjR2EKNGGkM3vXnwsBCp
         VWiYN0wWXHsZFwwVW7+zNnBG3toq/eNaGzxqry6PGNkKHx730tIRqKzebAEc6Wyw3eQd
         83VQ==
X-Gm-Message-State: AGi0PuYverzjp4g/NdesJyfbHah6snJCA6j44TkpyZ+DdBhND443GNjB
        FPkS77AaoeAknsHw1bMvpJurydUByA2n3wTPNY1GwejjIpnd45A5xCO//p0aRlV6CajpaN81XRp
        GpBNDXKbB5kEK
X-Received: by 2002:a1c:4e06:: with SMTP id g6mr12297711wmh.186.1586160843953;
        Mon, 06 Apr 2020 01:14:03 -0700 (PDT)
X-Google-Smtp-Source: APiQypKwMBLFNnx06Xg7R33lZRsYDWD174vo2cYUGnvooyZuYiXm04Mj41WanhVq8wulVZiL7LOPQg==
X-Received: by 2002:a1c:4e06:: with SMTP id g6mr12297690wmh.186.1586160843757;
        Mon, 06 Apr 2020 01:14:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:80e8:806f:a5f9:88dc? ([2001:b07:6468:f312:80e8:806f:a5f9:88dc])
        by smtp.gmail.com with ESMTPSA id a2sm16642088wra.71.2020.04.06.01.14.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Apr 2020 01:14:03 -0700 (PDT)
Subject: Re: ata driver loading hang on qemu/kvm
To:     Suresh Gumpula <suresh.gumpula@nutanix.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <D02A294C-2823-4137-BD1B-9A0F76270D2B@nutanix.com>
 <3752A519-BE1A-478F-920F-75F101807694@nutanix.com>
 <CFD00AFB-8B52-475E-8CB6-FCB7967E0316@nutanix.com>
 <1A6AC1FC-AED9-476C-9178-BE293E981E56@nutanix.com>
 <FF9D9722-4FA8-4630-AB3A-1D077D7D0991@nutanix.com>
 <34B5C17E-3022-419A-BCB2-5B938FF5E44D@nutanix.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <727709f7-ae9a-8614-d4ab-d53678f667f9@redhat.com>
Date:   Mon, 6 Apr 2020 10:14:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <34B5C17E-3022-419A-BCB2-5B938FF5E44D@nutanix.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/04/20 22:46, Suresh Gumpula wrote:
> 
> 
> From: Suresh Gumpula <suresh.gumpula@nutanix.com>
> Date: Sunday, April 5, 2020 at 1:40 PM
> To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
> Subject: Re: ata driver loading hang on qemu/kvm
> 
> The guest kernel(not a nested guest) boot iso is hanging with following errors.
> [    1.414035] Write protecting the kernel read-only data: 6144k
> [    1.418006] Freeing unused kernel memory: 1080K
> [    1.423033] Freeing unused kernel memory: 1004K
> [    1.466783] scsi host0: ata_piix
> [    1.469539] scsi host1: ata_piix
> [    1.472039] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc300 irq 14
> [    1.475740] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc308 irq 15
>  
>  
> We have enabled nested host, but not running any nested guests.  So it’s a regular guest VM on a host.
> Can someone please guide me what could be wrong here.  Is it a known issue in the kvm module or qemu emulation of IDE/CDROM controller?

No, it's the first time I see this reported.  Please try with a newer
QEMU version.

Paolo

