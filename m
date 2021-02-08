Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95E7A312E7E
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 11:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbhBHKCx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 05:02:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56212 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232163AbhBHJ66 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Feb 2021 04:58:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612778247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RvZB2MDYfZF1qZTLhRJJTQFx3HJrD/c9ga0gap1r0Iw=;
        b=V9niYLt78pI5ToVzJPRsE34XxwdN5kQBEW6nSIbfIwjJTconuYlyOIcf5yuefG1CbCRQE0
        wbbDvFuywg2IKxJsuwbYwLnOwagzxtNqEUxHFWI2BRFiofa/Yk286iv+YSdB7xYi7ceNKS
        sSPjmULFc7IReH6SuDilgItw6/ywHEI=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-Ic-5btMAPfS1ohFvxyjkJA-1; Mon, 08 Feb 2021 04:57:25 -0500
X-MC-Unique: Ic-5btMAPfS1ohFvxyjkJA-1
Received: by mail-ej1-f71.google.com with SMTP id yh28so11312563ejb.11
        for <kvm@vger.kernel.org>; Mon, 08 Feb 2021 01:57:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RvZB2MDYfZF1qZTLhRJJTQFx3HJrD/c9ga0gap1r0Iw=;
        b=d7FHec8TWt/Zcv9Nuu+giA7JJt41yh1T/3GbiXGnepP2z6nDCDHUH8zL89EklZpZsb
         +xnuz4QDcd2meei8o0yvFr7h/GO3W+8mZ/AGdCmaqU+sirqMAG8ynVS/UNWVVfGt/uLi
         HtSBsU93vAe2ofxYGvkMH7qhcYf8VpIhi3z5cVEQb3a5tFivnofxNGQGHc8L4p2aLqKu
         p7qJeG+UV/3uNsTpos37tVK9tijUF2MZhNCGzUCb99mlKDX+AgW9YM8xijvaKZXrah8x
         gUbmMLL8OsVaEin736SUFQaYqaRGCJ2oUzMVUxTSbL0WTxSIylp/K8UuVc+mn/+HQWsf
         jpLw==
X-Gm-Message-State: AOAM531QibpsUgBn4MIraLdf+zed6M+WZhocSgzDqRYUPJjSR6w+px+Y
        JBI6jtT19sN9oJiEDqbR3XzDg7xq7eJy69mrojQxXdlNnCEHO5+AzHxZpXrn/3sy/zo+9Z2ulg2
        jZOrMCyAAykoB
X-Received: by 2002:a17:906:69c2:: with SMTP id g2mr15591534ejs.249.1612778244680;
        Mon, 08 Feb 2021 01:57:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxuMkDMU86Gua486YyYkyE3So25auj8KdRwJTxDrTGf27Ev7G+jbzxJNKOribW4cbFKzGSizw==
X-Received: by 2002:a17:906:69c2:: with SMTP id g2mr15591508ejs.249.1612778244420;
        Mon, 08 Feb 2021 01:57:24 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id mh4sm5533387ejb.122.2021.02.08.01.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 01:57:23 -0800 (PST)
Date:   Mon, 8 Feb 2021 04:57:20 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     kernel test robot <oliver.sang@intel.com>
Cc:     Dongli Zhang <dongli.zhang@oracle.com>,
        Eli Cohen <elic@nvidia.com>, Jason Wang <jasowang@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        lkp@intel.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, pbonzini@redhat.com,
        stefanha@redhat.com, joe.jin@oracle.com,
        aruna.ramakrishna@oracle.com, parav@nvidia.com
Subject: Re: [vdpa_sim_net] 79991caf52:
 net/ipv4/ipmr.c:#RCU-list_traversed_in_non-reader_section
Message-ID: <20210208045641-mutt-send-email-mst@kernel.org>
References: <20210123080853.4214-1-dongli.zhang@oracle.com>
 <20210207030330.GB17282@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210207030330.GB17282@xsang-OptiPlex-9020>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Feb 07, 2021 at 11:03:30AM +0800, kernel test robot wrote:
> 
> Greeting,
> 
> FYI, we noticed the following commit (built with gcc-9):
> 
> commit: 79991caf5202c7989928be534727805f8f68bb8d ("vdpa_sim_net: Add support for user supported devices")
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git Dongli-Zhang/vhost-scsi-alloc-vhost_scsi-with-kvzalloc-to-avoid-delay/20210129-191605
> 
> 
> in testcase: trinity
> version: trinity-static-x86_64-x86_64-f93256fb_2019-08-28
> with following parameters:
> 
> 	runtime: 300s
> 
> test-description: Trinity is a linux system call fuzz tester.
> test-url: http://codemonkey.org.uk/projects/trinity/
> 
> 
> on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 8G
> 
> caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> 

Parav want to take a look?

-- 
MST

