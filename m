Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C193F85D1
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 12:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241629AbhHZKur (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 06:50:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49191 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240993AbhHZKuq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 06:50:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629974999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7hrIlQItnvuwO65TqR8fUyINojxoylNX4yfInG5lI9c=;
        b=Na5/uPl6mToWLBd4vx3X4jjIg14Jq9IfVzd3GlHo0lJA0lpTkV5Vck/J1DMX1sLo0/xQox
        uL+zTOCHZcKnpC0BR9HAsar41cyZbBmXkTfxqOhrI9ayWz1nXIHroFIUhNND2lOAJcO+VF
        reIuLeg6wPRIJUZQAc1rjDynwv3nuWs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-8GB9qpiKO8ymFkOu5YBDWw-1; Thu, 26 Aug 2021 06:49:58 -0400
X-MC-Unique: 8GB9qpiKO8ymFkOu5YBDWw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADEEE801A92;
        Thu, 26 Aug 2021 10:49:56 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.91])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B8D122855F;
        Thu, 26 Aug 2021 10:49:46 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id BCDBD18003AA; Thu, 26 Aug 2021 12:49:44 +0200 (CEST)
Date:   Thu, 26 Aug 2021 12:49:44 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     isaku.yamahata@gmail.com
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com, kvm@vger.kernel.org,
        isaku.yamahata@intel.com
Subject: Re: [RFC PATCH v2 18/44] hw/i386: refactor e820_add_entry()
Message-ID: <20210826104944.aapxf5nlrx25uvvc@sirius.home.kraxel.org>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <876d3849f5293e7902df6e6f1dc8e89662b42a6b.1625704981.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <876d3849f5293e7902df6e6f1dc8e89662b42a6b.1625704981.git.isaku.yamahata@intel.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 07, 2021 at 05:54:48PM -0700, isaku.yamahata@gmail.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> The following patch will utilize this refactoring.

More verbose commit message please.

thanks,
  Gerd

