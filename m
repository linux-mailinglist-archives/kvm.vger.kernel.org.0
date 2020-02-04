Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4B2152226
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 22:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbgBDV5T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 16:57:19 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:33842 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727468AbgBDV5S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 16:57:18 -0500
Received: by mail-qv1-f65.google.com with SMTP id o18so156402qvf.1
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2020 13:57:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o8PJJopMHRnW2Lc0cvuzqZJdPgsHNH4EmbqfPi2CudQ=;
        b=OH2U30gH+ZDmHD5RKklKpDEpNSUh2d5eNyvmYsHQBPN7ljSC5DhtSh97amEFql9+83
         HIKukiAIGsoEcookCeIj3IUimjLT45df6BDTvuoIo97U1KeQIHYtNEdNFu5RI5RlTo94
         5wxZ2VMVw23n+ITPWSknknHiTgiwthNe9VreGu8Ak3ShMZuF77zCdXwW+bOD1pC3+TPj
         cHpvtOPMDheERtzU01rUP+UH5fm5uyvTwTXecYfA3Vfie6gNJnHoWPx1I0HaXpEIa7d1
         XDwcPqTpjbFockMXiPTgzD/tqt3FHDIemmXEJopYHIVMf6OPHIBcjBniqMhd7BFvVtsU
         j3Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o8PJJopMHRnW2Lc0cvuzqZJdPgsHNH4EmbqfPi2CudQ=;
        b=e9mPl0ACE5rBSrL/R/ywgImmbek7jg5b+JkS111JFYMjCOL4cCjVM9sjt7e2pmQ1kh
         t9V/oWP98gGf80qWiivNkr1O+g5G4suexfgdaQnGRDo0L99ZSZimpsWIBuvzc1ihwtjT
         bfppVIBTabywkBOJncmhkxv4F/Io8SooD6/n/AJbE21yAF/v6wU7l6J4fKUXcC5SwI0H
         IOiLSzl45Vyv5U5LKvDlk9apqF2kwqzhRd0tIItyKproJACpRbBTDEGVPTQIeoN2TA2N
         deGGe2OkW23vx1L0BVO8G0E7dlOndm1n4ZmDH0syc0ur4KHwMOkMScqVgexgkJfG9wsz
         GV8Q==
X-Gm-Message-State: APjAAAXAS45roXrAodnsPfCXbU6tWGyMhoVpMU3b4Opo7EVdfJu6PBEc
        U3ajdJPKKoknsv+H0Ql+wHgI5w==
X-Google-Smtp-Source: APXvYqw8wHQQ0TYYiyrNaAoyP1/6XXQmpVV3cfhOYaaGrRAqGG/43MHnS1ojgBUHUfnNQbnIl0rsDw==
X-Received: by 2002:ad4:4511:: with SMTP id k17mr28109982qvu.135.1580853435966;
        Tue, 04 Feb 2020 13:57:15 -0800 (PST)
Received: from ?IPv6:2620:0:1004:a:6e2b:60f7:b51b:3b04? ([2620:0:1004:a:6e2b:60f7:b51b:3b04])
        by smtp.gmail.com with ESMTPSA id y26sm12042230qtv.28.2020.02.04.13.57.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2020 13:57:15 -0800 (PST)
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
 <ae788015-616f-96e6-3a0e-39c1911c4b01@google.com>
 <CAPcyv4ibWZgCSTqnYLicVR3vXeNKwuWSnV5K8fCwvyhz_h=0GQ@mail.gmail.com>
From:   Barret Rhoden <brho@google.com>
Message-ID: <fb4efb83-1a19-4fb7-a32a-477d5b5cd80a@google.com>
Date:   Tue, 4 Feb 2020 16:57:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAPcyv4ibWZgCSTqnYLicVR3vXeNKwuWSnV5K8fCwvyhz_h=0GQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/4/20 4:43 PM, Dan Williams wrote:
> Ah, got it, you only ended up at wanting namespace labels because
> there was no other way to carve up device-dax. That's changing as part
> of the efi_fake_mem= enabling and I have a patch set in the works to
> allow discontiguous sub-divisions of a device-dax range. Note that is
> this branch rebases frequently:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm.git/log/?h=libnvdimm-pending

Cool, thanks.  I'll check it out!

Barret
