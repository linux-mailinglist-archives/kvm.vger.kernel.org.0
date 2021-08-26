Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB8283F8523
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 12:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241131AbhHZKOL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 06:14:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22874 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233409AbhHZKOK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 06:14:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629972802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0a9FyQ8pkS9692Sgt+LnpoD5fEBDwGdQCkploFJtYOY=;
        b=GGaFdNSbkSnuxzn/+9FuYxBvNahh8z2Hj6esAPBn3+2KGsBklGd5YwYgesUOmJLB+A8LBw
        86oKLEA+JeMc0vY1kST/7CCwXm4n7AcZU1jfStFrW3NSumqXI6qGOs7c3divJMf5cwNRdJ
        sQBkm2bEvJkIOM8PMLGVX04uAiUkVQA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-P2LE4Q-cMCuIxU4yJ0A88Q-1; Thu, 26 Aug 2021 06:13:21 -0400
X-MC-Unique: P2LE4Q-cMCuIxU4yJ0A88Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA6A1800EB8;
        Thu, 26 Aug 2021 10:13:19 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.91])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6BECD5C22B;
        Thu, 26 Aug 2021 10:13:16 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 91BC018003AA; Thu, 26 Aug 2021 12:13:14 +0200 (CEST)
Date:   Thu, 26 Aug 2021 12:13:14 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     isaku.yamahata@gmail.com
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com, kvm@vger.kernel.org,
        isaku.yamahata@intel.com
Subject: Re: [RFC PATCH v2 04/44] vl: Introduce machine_init_done_late
 notifier
Message-ID: <20210826101314.bi5fkgelnkfo6d7b@sirius.home.kraxel.org>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <80ac3e382a248bac13662d4052d17c41f1c21e3a.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80ac3e382a248bac13662d4052d17c41f1c21e3a.1625704980.git.isaku.yamahata@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 07, 2021 at 05:54:34PM -0700, isaku.yamahata@gmail.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Introduce a new notifier, machine_init_done_late, that is notified after
> machine_init_done.  This will be used by TDX to generate the HOB for its
> virtual firmware, which needs to be done after all guest memory has been
> added, i.e. after machine_init_done notifiers have run.  Some code
> registers memory by machine_init_done().

Can you be more specific than "some code"?

I see only pc_memory_init() adding guest ram (and the corresponding e820
entries), and that should run early enough ...

thanks,
  Gerd

