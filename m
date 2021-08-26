Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C57773F86A4
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 13:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242290AbhHZLn4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 07:43:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37206 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233829AbhHZLnz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 07:43:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629978188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HuSdl8VPnaKESpbQBGNzdr2jJ0Gg3btzTyK1wnQfrJQ=;
        b=Wdh8a/+fAkZid2oVc+YOLQ0BXqg1UwHxmeZ4UCTSqUwaGrlFUE8yX4TAcZ8nxnCncJgXZm
        456/q7ublZDv8sIJoqCNFIXdifkoILPQ5S+9p7e8l8JqOBKcEPRmFr7IYQePX6Mooc2lCm
        Dsi5Zn1/xu8LRQVhf8RDAFVmThL5D9o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-iNApl4fXN7OaAWkLDEwwMQ-1; Thu, 26 Aug 2021 07:43:07 -0400
X-MC-Unique: iNApl4fXN7OaAWkLDEwwMQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F914100A609;
        Thu, 26 Aug 2021 11:43:05 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.91])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 216EC19D9F;
        Thu, 26 Aug 2021 11:43:01 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 914E418003AA; Thu, 26 Aug 2021 13:42:59 +0200 (CEST)
Date:   Thu, 26 Aug 2021 13:42:59 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     isaku.yamahata@gmail.com
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com, kvm@vger.kernel.org,
        isaku.yamahata@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH v2 28/44] i386/tdx: Force x2apic mode and routing for
 TDs
Message-ID: <20210826114259.7vdae6ysph4kzoqc@sirius.home.kraxel.org>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <5524acbf0b403fea046978456129d4c59a06f8a0.1625704981.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5524acbf0b403fea046978456129d4c59a06f8a0.1625704981.git.isaku.yamahata@intel.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 07, 2021 at 05:54:58PM -0700, isaku.yamahata@gmail.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> TDX requires x2apic and "resets" vCPUs to have x2apic enabled.  Model
> this in QEMU and unconditionally enable x2apic interrupt routing.

We have a cpu flag for that.  IMHO you should verify it is set and error
out if not instead of silently fixing up things.

take care,
  Gerd

