Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3296B2005FC
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 12:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732160AbgFSKFt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 06:05:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44253 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729195AbgFSKFs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jun 2020 06:05:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592561146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wOB/56I0E2vSbrY8/qvWcoDbR4ALjD0BWAr2SAMhSX0=;
        b=DdpljVLjmlJjuIndHG2YMbBTeirj8Tbe5zRoA5Hdj9+x0XssvMozCq1SnQH8hWG7xOE6S6
        u88eB5ny8f96qAt6k+ocv81VxRoshNRpWkOHlBQqPpjVMitghoSNm+ozYtpFT7NsQsm/d0
        ZI/gqWNcJ7F8RwK06Ng24rfs3dYS6SI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-dDbRV7HOMrmyUQ04EQbE4A-1; Fri, 19 Jun 2020 06:05:45 -0400
X-MC-Unique: dDbRV7HOMrmyUQ04EQbE4A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 11436107ACCA;
        Fri, 19 Jun 2020 10:05:43 +0000 (UTC)
Received: from gondolin (ovpn-112-224.ams2.redhat.com [10.36.112.224])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 964B31002394;
        Fri, 19 Jun 2020 10:05:33 +0000 (UTC)
Date:   Fri, 19 Jun 2020 12:05:30 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, pair@us.ibm.com, pbonzini@redhat.com,
        dgilbert@redhat.com, frankja@linux.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, qemu-ppc@nongnu.org, mst@redhat.com,
        mdroth@linux.vnet.ibm.com, Richard Henderson <rth@twiddle.net>,
        pasic@linux.ibm.com, Eduardo Habkost <ehabkost@redhat.com>,
        qemu-s390x@nongnu.org
Subject: Re: [PATCH v3 0/9] Generalize memory encryption models
Message-ID: <20200619120530.256c36cb.cohuck@redhat.com>
In-Reply-To: <79890826-f67c-2228-e98d-25d2168be3da@redhat.com>
References: <20200619020602.118306-1-david@gibson.dropbear.id.au>
        <e045e202-cd56-4ddc-8c1d-a2fe5a799d32@redhat.com>
        <20200619114526.6a6f70c6.cohuck@redhat.com>
        <79890826-f67c-2228-e98d-25d2168be3da@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 19 Jun 2020 11:56:49 +0200
David Hildenbrand <david@redhat.com> wrote:

> >>> For now this series covers just AMD SEV and POWER PEF.  I'm hoping it
> >>> can be extended to cover the Intel and s390 mechanisms as well,
> >>> though.    
> >>
> >> The only approach on s390x to not glue command line properties to the
> >> cpu model would be to remove the CPU model feature and replace it by the
> >> command line parameter. But that would, of course, be an incompatible break.  
> > 
> > Yuck.
> > 
> > We still need to provide the cpu feature to the *guest* in any case, no?  
> 
> Yeah, but that could be wired up internally. Wouldn't consider it clean,
> though (I second the "overengineered" above).

Could an internally wired-up cpu feature be introspected? Also, what
happens if new cpu features are introduced that have a dependency on or
a conflict with this one?

