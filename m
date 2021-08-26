Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48D2D3F8543
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 12:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241391AbhHZKYw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 06:24:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56265 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241317AbhHZKYt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 06:24:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629973442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KghYdQ02d5GN1f8jgPYvz3Sv8fjljwc+oeQsWyEvHUY=;
        b=FGVBv5+T5ylzA3EVTjggPNfHFD+9C5PNO8t3thKiS+Uq2+ROyAaAEeHHDNbioqHNV9DbEZ
        EaWL32axhqPbnxncisnho0iD0Mp1CF0dQMRRNc/NLZHPEs8peH/ITX7cEQyc5UWjZ1oI5w
        u7ZA1b+G5D7328vobhArM/kytgCMUIY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-CKEK4k2dO2qEin7uK9V4BQ-1; Thu, 26 Aug 2021 06:22:19 -0400
X-MC-Unique: CKEK4k2dO2qEin7uK9V4BQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32DB418C8C00;
        Thu, 26 Aug 2021 10:22:18 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.91])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E3C46060F;
        Thu, 26 Aug 2021 10:22:14 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 7A9B518003AA; Thu, 26 Aug 2021 12:22:12 +0200 (CEST)
Date:   Thu, 26 Aug 2021 12:22:12 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     isaku.yamahata@gmail.com
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com, kvm@vger.kernel.org,
        isaku.yamahata@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH v2 06/44] hw/i386: Introduce kvm-type for TDX guest
Message-ID: <20210826102212.gykq2z4fb2iszb2k@sirius.home.kraxel.org>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <04c08d0770736cfa2e3148489602bc42492c78f3.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04c08d0770736cfa2e3148489602bc42492c78f3.1625704980.git.isaku.yamahata@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 07, 2021 at 05:54:36PM -0700, isaku.yamahata@gmail.com wrote:
> From: Xiaoyao Li <xiaoyao.li@intel.com>
> 
> Introduce a machine property, kvm-type, to allow the user to create a
> Trusted Domain eXtensions (TDX) VM, a.k.a. a Trusted Domain (TD), e.g.:
> 
>  # $QEMU \
> 	-machine ...,kvm-type=tdx \
> 	...

Can we align sev and tdx better than that?

SEV is enabled this way:

qemu -machine ...,confidential-guest-support=sev0 \
     -object sev-guest,id=sev0,...

(see docs/amd-memory-encryption.txt for details).

tdx could likewise use a tdx-guest object (and both sev-guest and
tdx-guest should probably have a common parent object type) to enable
and configure tdx support.

take care,
  Gerd

