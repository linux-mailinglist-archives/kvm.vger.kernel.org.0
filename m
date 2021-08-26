Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BACB3F8714
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 14:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242474AbhHZMQD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 08:16:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27761 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242469AbhHZMQC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 08:16:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629980115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7zGor1pAi8Pv4p2D7vXiNRA/Bu6ID2uhk8gwuUCvznc=;
        b=Df9f+y1zRiWt6DFwI3pZ3FBFLZFWJL4r+woBDQcwD7XKtQSiM6W/Dp6BVn0/u9hYResS15
        wa1NqIB4kCYmngVebHwsOlGeTbgXlCE4oFPP22UKO6ba9V6m/hjuNa+JE/dYTQCMHtH8QO
        TNFvhI9+unLW9USzOW/8M8eJyne0syY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-8hjrYhzcM_2mOqHYO5SnSg-1; Thu, 26 Aug 2021 08:15:13 -0400
X-MC-Unique: 8hjrYhzcM_2mOqHYO5SnSg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 64C5B184F1A0;
        Thu, 26 Aug 2021 12:15:12 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.91])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F0AC360583;
        Thu, 26 Aug 2021 12:15:08 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 5E29A18003AA; Thu, 26 Aug 2021 14:15:07 +0200 (CEST)
Date:   Thu, 26 Aug 2021 14:15:07 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     isaku.yamahata@gmail.com
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com, kvm@vger.kernel.org,
        isaku.yamahata@intel.com
Subject: Re: [RFC PATCH v2 42/44] hw/i386: add a flag to disable init/sipi
 delivery mode of interrupt
Message-ID: <20210826121507.kaetaey7wocsiko5@sirius.home.kraxel.org>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <b11399727683e22ff53a14f15eb93f24eef1d49b.1625704981.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b11399727683e22ff53a14f15eb93f24eef1d49b.1625704981.git.isaku.yamahata@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  Hi,

>      ioapic_init_gsi(gsi_state, "machine", x86ms->eoi_intercept_unsupported,
> -                    x86ms->smi_unsupported);
> +                    x86ms->smi_unsupported, x86ms->init_sipi_unsupported);

Hmm, why add three different switches here?  I suspect these would all
be used together anyway?  So maybe just add a "tdx mode" to the ioapic?
Or maybe better a "confidential-computing" mode, as I guess amd will
have similar requirements for similar reasons?

thanks,
  Gerd

