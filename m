Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF201EF399
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 11:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgFEJAi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 05:00:38 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:59801 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726144AbgFEJAh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Jun 2020 05:00:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591347637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4jUUNbtjOK3UO/cSszeq9Crwr2dvyzKXsm27AIGCTyk=;
        b=es+IZh955tHxYmJceCGfQTuSwXhkAQDfCnDaefyVZPPpF1yojifh3hlGmvuD8ciGArBlgm
        83nlIftHuof1DxUj6eo0QnY5DXR61bwz8tV3++xcQHj6I0o/OaziH8/M6BGCOXfPZIAJOc
        za/JF0zMoIpCBtX8S2W8xiWo+cj4ODw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-lynZTGgcPDWu5VqYpv0oxA-1; Fri, 05 Jun 2020 05:00:32 -0400
X-MC-Unique: lynZTGgcPDWu5VqYpv0oxA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D42B3461;
        Fri,  5 Jun 2020 09:00:31 +0000 (UTC)
Received: from gondolin (ovpn-113-2.ams2.redhat.com [10.36.113.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B24B6610AF;
        Fri,  5 Jun 2020 09:00:27 +0000 (UTC)
Date:   Fri, 5 Jun 2020 11:00:25 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v7 09/12] s390x: css: msch, enable test
Message-ID: <20200605110025.4a360fe6.cohuck@redhat.com>
In-Reply-To: <3aaa9a99-6958-062d-14a7-fcf8d447ad19@linux.ibm.com>
References: <1589818051-20549-1-git-send-email-pmorel@linux.ibm.com>
        <1589818051-20549-10-git-send-email-pmorel@linux.ibm.com>
        <20200527114239.65fa9473.cohuck@redhat.com>
        <65501204-f6f3-7800-e382-63ccad77ca38@linux.ibm.com>
        <20200604152945.4cb433bd.cohuck@redhat.com>
        <ea12784c-df16-db4b-dd9c-b5b77bcbe9f9@linux.ibm.com>
        <3aaa9a99-6958-062d-14a7-fcf8d447ad19@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 5 Jun 2020 10:24:56 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> Hi Connie,
> 
> for the next series, I will move more code of the css.c to the css_lib.c 
> to be able to reuse it for other tests.
> One of your suggestions IIRC.
> So I will not be able to keep your RB until you have a look at the changes.
> I will keep the same algorithms but still...

np, I'll look at it again.

