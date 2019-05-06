Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 642FD15167
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 18:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbfEFQb7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 12:31:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47372 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727406AbfEFQb5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 May 2019 12:31:57 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3C08230842B5;
        Mon,  6 May 2019 16:31:57 +0000 (UTC)
Received: from gondolin (unknown [10.40.205.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7C44A5EDE4;
        Mon,  6 May 2019 16:31:55 +0000 (UTC)
Date:   Mon, 6 May 2019 18:31:52 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 7/7] s390/cio: Remove vfio-ccw checks of command codes
Message-ID: <20190506183152.53cf9d32.cohuck@redhat.com>
In-Reply-To: <d6f28324-846f-54b6-84f0-c97e474361c1@linux.ibm.com>
References: <20190503134912.39756-1-farman@linux.ibm.com>
        <20190503134912.39756-8-farman@linux.ibm.com>
        <20190506173707.40216e76.cohuck@redhat.com>
        <65313674-09be-88c0-4b5e-c99527f26532@linux.ibm.com>
        <20190506181850.4b1b8300.cohuck@redhat.com>
        <d6f28324-846f-54b6-84f0-c97e474361c1@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Mon, 06 May 2019 16:31:57 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 6 May 2019 12:25:01 -0400
Eric Farman <farman@linux.ibm.com> wrote:

> On 5/6/19 12:18 PM, Cornelia Huck wrote:

> > [1] tcws are a bit different; but we don't support them anyway.
> >   
> 
> Yeah...  I'd like to get the code cleaned up to a point where if we want 
> to support TCWs, we could just up front say "if command go here, if 
> transport go there."  Not that that'll be anytime soon, but it would 
> prevent us from having to dis-entangle everything at that future point.
> 

Let's see how much work that is :)
