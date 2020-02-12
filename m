Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 499CA15A74F
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 12:04:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbgBLLEL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 06:04:11 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29512 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727279AbgBLLEK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 06:04:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581505449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ssspBL21uJQbov7YjqcldFMmv1egFyHbr8CI9TZkpC4=;
        b=DGkYUye1WCkLNuVld6kf8cSAk68SWetk+zHzR5cRXEMjAu/r17zCQQ5YTtLTfcDF7lNAEO
        Jshg7McKkWBUKwbJH3smRjdlS87kAkUr2kw2x7HD8Ry/eYvEwCfpQFXRTqJgeAHEsEBoBf
        PNKwuu6tyhBh6LYDH7d+bLIDIIaxrBw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-w2iDiXEROPW5H-HhHsfMIg-1; Wed, 12 Feb 2020 06:04:05 -0500
X-MC-Unique: w2iDiXEROPW5H-HhHsfMIg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B28B1005502;
        Wed, 12 Feb 2020 11:04:04 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 83BF15C1B0;
        Wed, 12 Feb 2020 11:03:59 +0000 (UTC)
Date:   Wed, 12 Feb 2020 12:03:57 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH 35/35] DOCUMENTATION: Protected virtual machine
 introduction and IPL
Message-ID: <20200212120357.205e9ede.cohuck@redhat.com>
In-Reply-To: <a2e5f248-4d4d-5650-6f48-174bddd328f9@de.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
        <20200207113958.7320-36-borntraeger@de.ibm.com>
        <5d8050a6-c730-4325-2d46-2b5c9cdc8408@redhat.com>
        <a2e5f248-4d4d-5650-6f48-174bddd328f9@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 Feb 2020 21:03:17 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 11.02.20 13:23, Thomas Huth wrote:
> > On 07/02/2020 12.39, Christian Borntraeger wrote:  
> >> +The switch into PV mode lets us load encrypted guest executables and  
> > 
> > Maybe rather: "After the switch into PV mode, the guest can load ..." ?  
> 
> No its not after the switch. By doing the switch the guest image can be loaded
> fro anywhere because it is just like a kernel.
> 
> So I will do:
> 
> As the guest image is just like an opaque kernel image that does the
> switch into PV mode itself, the user can load encrypted guest
> executables and data via every available method (network, dasd, scsi,
> direct kernel, ...) without the need to change the boot process.

Sounds good to me.

(...)

> >> +All non-decrypted data of the guest before it switches to protected
> >> +virtualization mode are zero on first access of the PV.  
> > 
> > Before it switches to protected virtualization mode, all non-decrypted
> > data of the guest are ... ?  
> 
> No, this is about the data after the initial import.
> What about
> 
> After the initial import of the encrypted data all defined pages will

s/data/data,/

> contain the guest content. All non-specified pages will start out as
> zero pages on first access.

Also sounds good to me.

(...)

