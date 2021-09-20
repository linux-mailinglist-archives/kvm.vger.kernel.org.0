Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF85411881
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 17:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237662AbhITPmO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 11:42:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26900 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233446AbhITPmN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 11:42:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632152446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8jKM7Ph6fmLhb/9OPjqi0r/7DHC1tviPBdiTzxNTbGM=;
        b=ViHWYYvxHNrLo87oiNj3fduEUx2+LymnzVuj70F/HL953Dl0QMglDzrbUQlfR20hKqKvSy
        99iv6siKGFoBB4+98YQgsfZcB3jWh3kRtOwenqnK93XARZJF7ElYTdUNVSuYYlyo4trrnu
        8h8dnv0NtCUofRgFjSvFvRmYMJ/1D4I=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-vO88uPyRNmmM5fppiYL1aA-1; Mon, 20 Sep 2021 11:40:43 -0400
X-MC-Unique: vO88uPyRNmmM5fppiYL1aA-1
Received: by mail-wr1-f69.google.com with SMTP id c15-20020a5d4ccf000000b0015dff622f39so6449403wrt.21
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 08:40:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8jKM7Ph6fmLhb/9OPjqi0r/7DHC1tviPBdiTzxNTbGM=;
        b=oq33OZOm451mGdbGvQFtACLEaoO5vbdrb5WSqmoF0c6jhb+36aff2I5qczu/zA5da7
         2s+peCvNI48nWmgjdPA1fV2UM/lVea+A2fyzaHRCfuV+5nhTHZ2sroqXARfWt47jHm/H
         M6CKM777+dqhqGEEXRhkrPS3i1R9eEotKu3t71mtyKPeRzVPZ8+9HFb+LFJECY5MtZGV
         cc/u6NQf7FL8DWwZoI6+Mzvr4GB9m9JLAlT9wLhzsn5LNhXYKsd59DEtZ3rVc3ItbHkD
         2LhRO49i+lbKOxHECjCoQKpD9drJrsN3bNzcmNjKf80pvuGIyCC3rmOHEgkbjjT4Z8I8
         Twkw==
X-Gm-Message-State: AOAM530HyhYtpYsawfhlhmlLrypOvWGZ0AJHNVIzKUMnqFtrgUcpg53G
        X+l+H5dyiJCVxqgJWaDZtMYgza85MU/7iDVms00qp+neyGS6H20lr1smiWNAOs/aKhdb2iEeWv/
        WGIJCGgojYECF
X-Received: by 2002:a5d:54cf:: with SMTP id x15mr30095227wrv.27.1632152441193;
        Mon, 20 Sep 2021 08:40:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz5hk6cVRyQM7TyOrDYsrLGqXQTNz3AUPRU+QS+igBYS2RmJbS8iKkgzmSNBSRiFC8w0RdQtA==
X-Received: by 2002:a5d:54cf:: with SMTP id x15mr30095200wrv.27.1632152440933;
        Mon, 20 Sep 2021 08:40:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p6sm15771113wrq.47.2021.09.20.08.40.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 08:40:40 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 06/17] x86 UEFI: Load GDT and TSS after
 UEFI boot up
To:     Zixuan Wang <zixuanwang@google.com>, kvm@vger.kernel.org,
        drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de
References: <20210827031222.2778522-1-zixuanwang@google.com>
 <20210827031222.2778522-7-zixuanwang@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <47de7f60-cfe7-0207-9c68-01dc38acc857@redhat.com>
Date:   Mon, 20 Sep 2021 17:40:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210827031222.2778522-7-zixuanwang@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/08/21 05:12, Zixuan Wang wrote:
> +.globl gdt64
> +gdt64:
> +	.quad 0
> +	.quad 0x00af9b000000ffff /* 64-bit code segment */
> +	.quad 0x00cf93000000ffff /* 32/64-bit data segment */
> +	.quad 0x00af1b000000ffff /* 64-bit code segment, not present */
> +	.quad 0x00cf9b000000ffff /* 32-bit code segment */
> +	.quad 0x008f9b000000FFFF /* 16-bit code segment */
> +	.quad 0x008f93000000FFFF /* 16-bit data segment */
> +	.quad 0x00cffb000000ffff /* 32-bit code segment (user) */
> +	.quad 0x00cff3000000ffff /* 32/64-bit data segment (user) */
> +	.quad 0x00affb000000ffff /* 64-bit code segment (user) */
> +
> +	.quad 0			 /* 6 spare selectors */
> +	.quad 0
> +	.quad 0
> +	.quad 0
> +	.quad 0
> +	.quad 0
> +
> +tss_descr:
> +	.rept max_cpus
> +	.quad 0x000089000000ffff /* 64-bit avail tss */
> +	.quad 0                  /* tss high addr */
> +	.endr
> +gdt64_end:
> 
> +.globl tss
> +tss:
> +	.rept max_cpus
> +	.long 0
> +	.quad 0
> +	.quad 0, 0
> +	.quad 0, 0, 0, 0, 0, 0, 0, 0
> +	.long 0, 0, 0
> +	.endr
> +tss_end:
> +

Please place the IDT (from the previous patch), GDT and TSS in a common 
source file for both UEFI and multiboot.  It could in fact be 
lib/x86/desc.c even.

Duplicating the descriptors is fine, since they're only referred from 
the startup code.

Paolo

