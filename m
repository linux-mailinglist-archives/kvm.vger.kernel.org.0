Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D82D21BF552
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 12:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgD3KZt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 06:25:49 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55947 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726427AbgD3KZs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Apr 2020 06:25:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588242348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BneciSZWv8egZ/kJqLEEA8fM87/5q3bkm5fxN2lImyY=;
        b=T4PToQCy4kFWBxShaMzd9l6VOJ8wAUt1MVgXISbd3eio4LLd0yE3nZ8S9WDmee5xv0FESr
        2q+TaclxZqhJKI6nvmX0wg2MOaBVb37HvL1V6ppafiHBXM/U98YiGKCYYgjKsVwBCOiAOB
        ejFbxcEmkhf5R2hq/WI9VW8j1P0WBjM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-65zu-RS-MuiAbAD2aYpWLA-1; Thu, 30 Apr 2020 06:25:46 -0400
X-MC-Unique: 65zu-RS-MuiAbAD2aYpWLA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E1BE80B70B
        for <kvm@vger.kernel.org>; Thu, 30 Apr 2020 10:25:45 +0000 (UTC)
Received: from gondolin (ovpn-112-226.ams2.redhat.com [10.36.112.226])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DD9BE5EDEA;
        Thu, 30 Apr 2020 10:25:43 +0000 (UTC)
Date:   Thu, 30 Apr 2020 12:25:14 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Kashyap Chamarthy <kchamart@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, dgilbert@redhat.com,
        vkuznets@redhat.com
Subject: Re: [PATCH v2] docs/virt/kvm: Document running nested guests
Message-ID: <20200430122514.0a9a2c99.cohuck@redhat.com>
In-Reply-To: <20200427152249.GB25403@paraplu>
References: <20200420111755.2926-1-kchamart@redhat.com>
        <20200422105618.22260edb.cohuck@redhat.com>
        <20200427152249.GB25403@paraplu>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 27 Apr 2020 17:22:49 +0200
Kashyap Chamarthy <kchamart@redhat.com> wrote:

> On Wed, Apr 22, 2020 at 10:56:18AM +0200, Cornelia Huck wrote:
> > On Mon, 20 Apr 2020 13:17:55 +0200
> > Kashyap Chamarthy <kchamart@redhat.com> wrote:  

> > > +
> > > +  - Output of: ``dmidecode`` from L0
> > > +
> > > +  - Output of: ``dmidecode`` from L1  
> > 
> > This looks x86 specific? Maybe have a list of things that make sense
> > everywhere, and list architecture-specific stuff in specific
> > subsections?  
> 
> Can do.  Do you have any other specific debugging bits to look out for
> s390x or any other arch?

Not from the top of my head... but we can easily add something later on
anyway.

