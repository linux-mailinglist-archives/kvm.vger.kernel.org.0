Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1123F85CC
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 12:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234351AbhHZKrB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 06:47:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50586 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233311AbhHZKrB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 06:47:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629974773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s3WcmJ5Ui/dKQrqpANopt+Dr27EgvA5aiUNsObX9q80=;
        b=HTpk97PxCfoXtPnvpLkdj0j+N6/ngPgo3HXBuchc93Mxhxy3mRyUB1lJCntnFY8aDaMQc7
        v3CKm9hJLtbPbBNNpGDeW2SSBnH8qyvGsQEdBgTKeRCLgfffgJMRW6vm5wLl4ErgKJlIeo
        KGVmE5kKzQ6TetUkX6HgC5TzpRGIfRs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-X2-7eMNRMY6yVNTQRx2AZw-1; Thu, 26 Aug 2021 06:46:12 -0400
X-MC-Unique: X2-7eMNRMY6yVNTQRx2AZw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ACD7FEC1A0;
        Thu, 26 Aug 2021 10:46:10 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.91])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3286A3AC1;
        Thu, 26 Aug 2021 10:46:06 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 3DE4B18003AA; Thu, 26 Aug 2021 12:46:04 +0200 (CEST)
Date:   Thu, 26 Aug 2021 12:46:04 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     isaku.yamahata@gmail.com
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com, kvm@vger.kernel.org,
        isaku.yamahata@intel.com
Subject: Re: [RFC PATCH v2 16/44] hw/i386: Add definitions from UEFI spec for
 volumes, resources, etc...
Message-ID: <20210826104604.azrbz3ltyahu2epy@sirius.home.kraxel.org>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <c7e6adac59151440d899bc54705ced2c4cf162e4.1625704981.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7e6adac59151440d899bc54705ced2c4cf162e4.1625704981.git.isaku.yamahata@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 07, 2021 at 05:54:46PM -0700, isaku.yamahata@gmail.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add definitions for literals, enums, structs, GUIDs, etc... that will be
> used by TDX to build the UEFI Hand-Off Block (HOB) that is passed to the
> Trusted Domain Virtual Firmware (TDVF).  All values come from the UEFI
> specification and TDVF design guide. [1]

Looks like copied completely from somewhere else?
If so please add the source.

Also it should go to some place below include/standard-headers/

take care,
  Gerd

