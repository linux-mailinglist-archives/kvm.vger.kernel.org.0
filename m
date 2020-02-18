Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAC53162D39
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 18:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgBRRnU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 12:43:20 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:52352 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726403AbgBRRnU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Feb 2020 12:43:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582047799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TfYhihsaYpl3SkYCARZ0aqJoWgwAg50MspLeC6Tkzks=;
        b=K6FPF3MoVio0MskX9dWLSgtI9flaNFKK0qiiG/d8NUz+hIL3aYejwOh7GOWWAFtIZWpgsa
        VydLJuj7xLr0EguRnkgwYnQaaFEGwdfeLfDQeh+WqajkglK3Ihvk2j365zHK2p5x9dGG8S
        XjfBn6dprg2g/mVx8AB9bybAnnHLD4c=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-lbTS1NPMPeaPvDyENj_uDQ-1; Tue, 18 Feb 2020 12:43:13 -0500
X-MC-Unique: lbTS1NPMPeaPvDyENj_uDQ-1
Received: by mail-qv1-f71.google.com with SMTP id g6so12894538qvp.0
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2020 09:43:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TfYhihsaYpl3SkYCARZ0aqJoWgwAg50MspLeC6Tkzks=;
        b=XYV2cuX9Fk2OD6Z6mjOE3Yw8kYS9Bd6r3KssNxAkttI88wgrYC0ptJ/3unnMWHuKh5
         hXpBSDHkPWASbEhspsoRojpiL1dtCXnfa2tL4wrmIvPBXf4/qX2TohWJ9WoWgbLXPVDQ
         rvQFcX7U9shrDqNSMD/gGv+zuSCAjvx/TfqsGcArNkVhHCu+NKiM/B2X2JQkiUZ9wWTn
         Qgag0663akqYMidRwFv2QR9nK2mzCE3ptVzWmC44Kgw//rUytUhJcIlM/PGKxyPjTdO2
         2NnhoFW0RZISvan8PJE61QvdY/wNv5BEyi5lpL6LV116QZcJmpCjJgRIKWCQHqY2oeTQ
         g34Q==
X-Gm-Message-State: APjAAAWzZFsMtzq7V0VtBrqhUEoEi6ShNDtiEBUmZi8Du19YdO/aMmX8
        VhG4RiNWS9TeBtTPLgluWuDSiQrp2jXQ1Oa1yE9S3trlqUCjx5mOTHoVzOCRosAj8RYdv9D3dPT
        tN4LUhU8muaIT
X-Received: by 2002:a05:620a:31b:: with SMTP id s27mr19105392qkm.105.1582047793366;
        Tue, 18 Feb 2020 09:43:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqzEfUwxeApmuqHCYNkA6PIzorHdByG7gaY1ai/ZL45FYYxc67zZuAe9vAnHLOPrvPwIAM0r+w==
X-Received: by 2002:a05:620a:31b:: with SMTP id s27mr19105379qkm.105.1582047793149;
        Tue, 18 Feb 2020 09:43:13 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id j58sm2246253qtk.27.2020.02.18.09.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 09:43:12 -0800 (PST)
Date:   Tue, 18 Feb 2020 12:43:11 -0500
From:   Peter Xu <peterx@redhat.com>
To:     "Zhoujian (jay)" <jianjay.zhou@huawei.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "quintela@redhat.com" <quintela@redhat.com>,
        "Liujinsong (Paul)" <liu.jinsong@huawei.com>,
        "linfeng (M)" <linfeng23@huawei.com>,
        "wangxin (U)" <wangxinxin.wang@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>
Subject: Re: RFC: Split EPT huge pages in advance of dirty logging
Message-ID: <20200218174311.GE1408806@xz-x1>
References: <B2D15215269B544CADD246097EACE7474BAF9AB6@DGGEMM528-MBX.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <B2D15215269B544CADD246097EACE7474BAF9AB6@DGGEMM528-MBX.china.huawei.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 18, 2020 at 01:13:47PM +0000, Zhoujian (jay) wrote:
> Hi all,
> 
> We found that the guest will be soft-lockup occasionally when live migrating a 60 vCPU,
> 512GiB huge page and memory sensitive VM. The reason is clear, almost all of the vCPUs
> are waiting for the KVM MMU spin-lock to create 4K SPTEs when the huge pages are
> write protected. This phenomenon is also described in this patch set:
> https://patchwork.kernel.org/cover/11163459/
> which aims to handle page faults in parallel more efficiently.
> 
> Our idea is to use the migration thread to touch all of the guest memory in the
> granularity of 4K before enabling dirty logging. To be more specific, we split all the
> PDPE_LEVEL SPTEs into DIRECTORY_LEVEL SPTEs as the first step, and then split all
> the DIRECTORY_LEVEL SPTEs into PAGE_TABLE_LEVEL SPTEs as the following step.

IIUC, QEMU will prefer to use huge pages for all the anonymous
ramblocks (please refer to ram_block_add):

        qemu_madvise(new_block->host, new_block->max_length, QEMU_MADV_HUGEPAGE);

Another alternative I can think of is to add an extra parameter to
QEMU to explicitly disable huge pages (so that can even be
MADV_NOHUGEPAGE instead of MADV_HUGEPAGE).  However that should also
drag down the performance for the whole lifecycle of the VM.  A 3rd
option is to make a QMP command to dynamically turn huge pages on/off
for ramblocks globally.  Haven't thought deep into any of them, but
seems doable.

Thanks,

-- 
Peter Xu

