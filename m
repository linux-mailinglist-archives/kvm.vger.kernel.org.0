Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A35823F8699
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 13:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242204AbhHZLjP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 07:39:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38237 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233829AbhHZLjJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 07:39:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629977902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u2PgJEZnx+tvPMvdEmrhLWHjONlR24wEnc+tJpOhAl4=;
        b=c4oKzQkPu02ZgIsu0SxI7v3GA7qseI1kF556UX2tFLaLyRbrk7KHCHbLAQYVKRFzkpAncY
        OVnk/KjedZTIhbZ0LsjD83sYfR5bLyQ9PaNco4Z2wJgHm0v+LwnEMQDZAT15mo+tHNlbIp
        vy3aIqPNPbf8wkjZ6SZ2R/CpkHgGJzE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-nvOca9XMPpCswdwQfpBtsQ-1; Thu, 26 Aug 2021 07:38:20 -0400
X-MC-Unique: nvOca9XMPpCswdwQfpBtsQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B8DA193F560;
        Thu, 26 Aug 2021 11:38:19 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.91])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A3B56100238C;
        Thu, 26 Aug 2021 11:38:15 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 0141218003AA; Thu, 26 Aug 2021 13:38:13 +0200 (CEST)
Date:   Thu, 26 Aug 2021 13:38:13 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     isaku.yamahata@gmail.com
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com, kvm@vger.kernel.org,
        isaku.yamahata@intel.com,
        Isaku Yamahata <isaku.yamahata@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH v2 27/44] q35: Introduce smm_ranges property for
 q35-pci-host
Message-ID: <20210826113813.gfxnnpn6i5kdu2wg@sirius.home.kraxel.org>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <32a79698d8c585cbf34e92d558ef9250ebba85ab.1625704981.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32a79698d8c585cbf34e92d558ef9250ebba85ab.1625704981.git.isaku.yamahata@intel.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 07, 2021 at 05:54:57PM -0700, isaku.yamahata@gmail.com wrote:
> From: Isaku Yamahata <isaku.yamahata@linux.intel.com>
> 
> Add a q35 property to check whether or not SMM ranges, e.g. SMRAM, TSEG,
> etc... exist for the target platform.  TDX doesn't support SMM and doesn't
> play nice with QEMU modifying related guest memory ranges.

"qemu -M q35,smm=off" doesn't work?
If so: what is the exact problem?

take care,
  Gerd

