Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16DB1152A07
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 12:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgBELkj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 06:40:39 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27506 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727170AbgBELki (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 06:40:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580902837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WNqR7ULu5EzDjUknThEwmlTc7mP/+0VWPiZs8DBbl54=;
        b=ivjHwXmaL1vcdw0PI20JduZ+kOI04joZFidAxbVY9nRLPX3Sp7VkSa8vgAUoway1YHSanS
        Tdv9xqDyb4m391J690HLqG2vUC/B8rQ5oRPQHxHU/cfeUblEuWj1MkcImVkWgxwMLD5uNK
        EBTgaUPjGG1YSx1AfN+bC8YQBPihgEM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-AUHLJOy3OBm3pewtVUGXlw-1; Wed, 05 Feb 2020 06:40:36 -0500
X-MC-Unique: AUHLJOy3OBm3pewtVUGXlw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E02A4113784C;
        Wed,  5 Feb 2020 11:40:34 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 157B360BFB;
        Wed,  5 Feb 2020 11:40:30 +0000 (UTC)
Date:   Wed, 5 Feb 2020 12:40:28 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 00/37] KVM: s390: Add support for protected VMs
Message-ID: <20200205124028.20d76acf.cohuck@redhat.com>
In-Reply-To: <4970de81-1df9-85bf-efcc-f2705b90c4b4@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <8297d9a4-0d4a-1df0-d2a9-c980e4b2827c@redhat.com>
        <4970de81-1df9-85bf-efcc-f2705b90c4b4@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 5 Feb 2020 12:38:07 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 05.02.20 12:34, David Hildenbrand wrote:
> 
> > Due to the huge amount of review feedback (which makestime-consuming to
> > review if one doesn't want to comment the same thing again), I suggest
> > sending a new RFC rather soon-ish (e.g., on a weekly basis) - if nobody
> > objects. Would at least make my life easier :)  
> 
> I can send one this evening?
> 

Perhaps not that fast; I have not yet made my way through all patches
yet... let's wait until the end of the week?

