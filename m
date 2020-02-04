Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E68315205B
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 19:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbgBDSU1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 13:20:27 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41309 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727359AbgBDSU1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 13:20:27 -0500
Received: by mail-pl1-f195.google.com with SMTP id t14so7592070plr.8
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2020 10:20:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CAMBy3NGAyHNH2wCGCsteiJRgCMQA3d7e+wpMMPzaNM=;
        b=dBA6JtY8VAIHgTSG/m3Mm694yoeeGq0PpedkAvgfVdygHk+yDxvbEkaI0OZgAruXCd
         Oqxs/pAIkdyQh3FUG6RW6hx5Jm+8ioqk1rDFVpeB4P7NAkkgWAwIHKgE5toPWVQ/Gfp4
         spH3EiYZ+2IrGNIGbKXv45ye3A6lTdm7929uTztEkFX0h/iyZ/JsRt5CDrtU/vfVKq4d
         gbIZHXJKSkEDYaUeRZlPLXThNErMfFRfj3ZS5FK665oPREjtQwyQaLevKqdqy4HinU68
         F7UvQkHg8tQdVE6eajwq41kb0fIzVHYnWkT+AJoHJ1OQFbiJxHHeWYi12IuU9pcbg+4j
         zxhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CAMBy3NGAyHNH2wCGCsteiJRgCMQA3d7e+wpMMPzaNM=;
        b=hhSEI8b+JrjOQTMCYhQAo0IMzXL1uFbyxr98lqlC0B8jLKAX2mbqhqyRx0ltb4a4nq
         3dCp/z15PqgXSZ3lH9LBx3xqoPEh03wCRMTBlR+v+W4MONZRubX6X4Gvx7pPX+0zxD9i
         i8lGr++9VxjFHtUeBd7jrYRfkL2gV0oT11422l3j8eBEDkKo4gcW6VNejCqS3r4q2ZND
         E/K46iqynWkuPRlz0qrrvZIV7MfFdiYVyl3PNcBmuL06i3aBmzbxxGzdAvzxaH+DqOBi
         k3I7qxwXeNPehc2aGreb6jL++VcWU0GvLOB5PVDDqwIzNiSrFjh/0VprkVVpTQpzzr75
         CNRg==
X-Gm-Message-State: APjAAAXVthpMPVXezJp803f5HHrNUoJv/5LXpIeQ3i2Fwk8LIRf94Dtz
        6DdKl22tj8EqddpJc0w+118qPw==
X-Google-Smtp-Source: APXvYqwRjsxFHkomjw16464hTqweh60BpZMJ6xeDoW9lFDkzNpbofpmThIZb3diiY9PJQguYwiSX3A==
X-Received: by 2002:a17:90a:cb11:: with SMTP id z17mr468603pjt.122.1580840424859;
        Tue, 04 Feb 2020 10:20:24 -0800 (PST)
Received: from gnomeregan.cam.corp.google.com ([2620:15c:6:14:50b7:ffca:29c4:6488])
        by smtp.googlemail.com with ESMTPSA id f127sm25578589pfa.112.2020.02.04.10.20.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2020 10:20:24 -0800 (PST)
Subject: Re: [PATCH RFC 10/10] nvdimm/e820: add multiple namespaces support
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Joao Martins <joao.m.martins@oracle.com>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        KVM list <kvm@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        Liran Alon <liran.alon@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
References: <20200110190313.17144-1-joao.m.martins@oracle.com>
 <20200110190313.17144-11-joao.m.martins@oracle.com>
 <e605fed8-46f5-6a07-11e6-2cc079a1159b@google.com>
 <CAPcyv4iiSsEOsfEwLQcV3bNDjBSxw1OgWoBdEWPQEymq6=xm-A@mail.gmail.com>
From:   Barret Rhoden <brho@google.com>
Message-ID: <ae788015-616f-96e6-3a0e-39c1911c4b01@google.com>
Date:   Tue, 4 Feb 2020 13:20:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAPcyv4iiSsEOsfEwLQcV3bNDjBSxw1OgWoBdEWPQEymq6=xm-A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi -

On 2/4/20 11:44 AM, Dan Williams wrote:
> On Tue, Feb 4, 2020 at 7:30 AM Barret Rhoden <brho@google.com> wrote:
>>
>> Hi -
>>
>> On 1/10/20 2:03 PM, Joao Martins wrote:
>>> User can define regions with 'memmap=size!offset' which in turn
>>> creates PMEM legacy devices. But because it is a label-less
>>> NVDIMM device we only have one namespace for the whole device.
>>>
>>> Add support for multiple namespaces by adding ndctl control
>>> support, and exposing a minimal set of features:
>>> (ND_CMD_GET_CONFIG_SIZE, ND_CMD_GET_CONFIG_DATA,
>>> ND_CMD_SET_CONFIG_DATA) alongside NDD_ALIASING because we can
>>> store labels.
>>
>> FWIW, I like this a lot.  If we move away from using memmap in favor of
>> efi_fake_mem, ideally we'd have the same support for full-fledged
>> pmem/dax regions and namespaces that this patch brings.
> 
> No, efi_fake_mem only supports creating dax-regions. What's the use
> case that can't be satisfied by just specifying multiple memmap=
> ranges?

I'd like to be able to create and destroy dax regions on the fly.  In 
particular, I want to run guest VMs using the dax files for guest 
memory, but I don't know at boot time how many VMs I'll have, or what 
their sizes are.  Ideally, I'd have separate files for each VM, instead 
of a single /dev/dax.

I currently do this with fs-dax with one big memmap region (ext4 on 
/dev/pmem0), and I use the file system to handle the 
creation/destruction/resizing and metadata management.  But since fs-dax 
won't work with device pass-through, I started looking at dev-dax, with 
the expectation that I'd need some software to manage the memory (i.e. 
allocation).  That led me to ndctl, which seems to need namespace labels 
to have the level of control I was looking for.

Thanks,

Barret

