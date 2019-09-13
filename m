Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3345B18CA
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 09:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbfIMHUl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 03:20:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43192 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbfIMHUk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 03:20:40 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A08E4C0568FA;
        Fri, 13 Sep 2019 07:20:40 +0000 (UTC)
Received: from gondolin (ovpn-116-232.ams2.redhat.com [10.36.116.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 994A019C5B;
        Fri, 13 Sep 2019 07:20:33 +0000 (UTC)
Date:   Fri, 13 Sep 2019 09:20:30 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: s390: Do not leak kernel stack data in the
 KVM_S390_INTERRUPT ioctl
Message-ID: <20190913092030.373a9254.cohuck@redhat.com>
In-Reply-To: <239c8d0f-40fb-264a-bc10-445931a3cd9a@redhat.com>
References: <20190912090050.20295-1-thuth@redhat.com>
        <6905df78-95f0-3d6d-aaae-910cd2d7a232@redhat.com>
        <253e67f6-0a41-13e8-4ca2-c651d5fcdb69@redhat.com>
        <f9d07b66-a048-6626-e209-9fe455a2bed3@de.ibm.com>
        <239c8d0f-40fb-264a-bc10-445931a3cd9a@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Fri, 13 Sep 2019 07:20:40 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Sep 2019 13:23:38 +0200
Thomas Huth <thuth@redhat.com> wrote:

> Hmm, we already talked about deprecating support for pre-3.15 kernel
> stuff in the past (see
> https://wiki.qemu.org/ChangeLog/2.12#Future_incompatible_changes for
> example),

Btw: did we ever do that? I don't quite recall what code we were
talking about...
