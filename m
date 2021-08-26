Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA8A3F8546
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 12:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241092AbhHZKZT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 06:25:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43233 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241202AbhHZKZR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 06:25:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629973470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PemqTEeD87K9YnXAz88Qs6XOv4/freTkA8rMJeFI0X0=;
        b=JyFR54jblG21fR2YxPjnA3zAtXwZOOL7mwKeQ5lB8QzqdRr1N+lfWVv62E7Hmbvn7Ex6G8
        t1fSb9xuU/WQ/zkM8RTWriBDpHH6YK8869IjN2QOIx3Aehp2Ghf607t10PsbBKJt+IUQgS
        zGSq8uasCqY1i5vGBGfdSxJBkiS5v/s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-GRDbbpfSOMObprxT86KMfw-1; Thu, 26 Aug 2021 06:24:29 -0400
X-MC-Unique: GRDbbpfSOMObprxT86KMfw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 924061008065;
        Thu, 26 Aug 2021 10:24:27 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.91])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 47B6718428;
        Thu, 26 Aug 2021 10:24:23 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id AD08018003AA; Thu, 26 Aug 2021 12:24:21 +0200 (CEST)
Date:   Thu, 26 Aug 2021 12:24:21 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     isaku.yamahata@gmail.com
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com, kvm@vger.kernel.org,
        isaku.yamahata@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH v2 07/44] i386/kvm: Squash getting/putting guest
 state for TDX VMs
Message-ID: <20210826102421.bwslsyeafmullmky@sirius.home.kraxel.org>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
 <7194a76cfb8541d4f7a5b6a04fb3496bc14eab15.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7194a76cfb8541d4f7a5b6a04fb3496bc14eab15.1625704980.git.isaku.yamahata@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 07, 2021 at 05:54:37PM -0700, isaku.yamahata@gmail.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Ignore get/put state of TDX VMs as accessing/mutating guest state of
> producation TDs is not supported.

Why silently ignore instead of returning an error?

take care,
  Gerd

