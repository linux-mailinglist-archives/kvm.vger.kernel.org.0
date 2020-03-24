Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E08C5190D02
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 13:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbgCXMEd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 08:04:33 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:27218 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727266AbgCXMEd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 08:04:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585051472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NiCqF//tVw/io1Cyxk4FpzuDo5uMwngwgx4I+RDpkME=;
        b=NdmLMUmd540bI8YzHlPOygPZLPwFpK/xe4rGBnMbPE0TVcAd6lc5V38srGY5XXmZMtmgJG
        TA7aWkdrFIrWLH6cQ67g6VggmnIV2VUetlrx5HfXtrTT67UW+HqwbIgd+gBybyx5O7e7DB
        /BFTZQMTtCCpBNX/1iw0+/zMpOKTXzc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-pmGem-kDNkGgal4qLWOJ5Q-1; Tue, 24 Mar 2020 08:04:30 -0400
X-MC-Unique: pmGem-kDNkGgal4qLWOJ5Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1F34107ACC9;
        Tue, 24 Mar 2020 12:04:27 +0000 (UTC)
Received: from gondolin (ovpn-113-109.ams2.redhat.com [10.36.113.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DAE255DA66;
        Tue, 24 Mar 2020 12:04:23 +0000 (UTC)
Date:   Tue, 24 Mar 2020 13:04:21 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, linux-s390@vger.kernel.org,
        david@redhat.com
Subject: Re: [kvm-unit-tests PATCH 03/10] s390x: smp: Test stop and store
 status on a running and stopped cpu
Message-ID: <20200324130421.59073da7.cohuck@redhat.com>
In-Reply-To: <20200324081251.28810-4-frankja@linux.ibm.com>
References: <20200324081251.28810-1-frankja@linux.ibm.com>
        <20200324081251.28810-4-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 24 Mar 2020 04:12:44 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

> Let's also test the stop portion of the "stop and store status" sigp
> order.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/smp.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

