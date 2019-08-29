Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF62A195A
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 13:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727204AbfH2Ltz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 07:49:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33374 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726637AbfH2Ltz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 07:49:55 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F1E0281129;
        Thu, 29 Aug 2019 11:49:54 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B4028600C1;
        Thu, 29 Aug 2019 11:49:48 +0000 (UTC)
Date:   Thu, 29 Aug 2019 13:49:47 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: s390: Test for bad access register at the start of
 S390_MEM_OP
Message-ID: <20190829134947.167bae1d.cohuck@redhat.com>
In-Reply-To: <d2a3c09c-bb99-e065-22f3-6eda3e9a2581@redhat.com>
References: <20190829105356.27805-1-thuth@redhat.com>
        <20190829131845.5a72231a.cohuck@redhat.com>
        <d2a3c09c-bb99-e065-22f3-6eda3e9a2581@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 29 Aug 2019 11:49:55 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 29 Aug 2019 13:47:59 +0200
Thomas Huth <thuth@redhat.com> wrote:

> On 29/08/2019 13.18, Cornelia Huck wrote:
> [...]
> > 
> > Btw: should Documentation/virt/kvm/api.txt spell out the valid range
> > for ar explicitly?
> >   
> 
> That certainly would not hurt. Care to send a patch, or shall I assemble
> one?
> 
>  Thomas

Will do.
