Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1E0116EDC
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2019 15:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727734AbfLIOVR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Dec 2019 09:21:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31313 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727496AbfLIOVQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Dec 2019 09:21:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575901275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=zgj9vQF/fTAeoDAjrX8bS4Of9yiIqtQcuuBd/16/UWA=;
        b=Mu7ShQKURK8RNbgWkU1/E5rJtgLS6+ThrqLd9Tz0LBLAcUqKFbpUrn5bm1FRCoXp5qFOyZ
        iKeGrnEFHOjitElZ/tEh6ozMC2dUQ1wEaIShChd2hg2+Ghbh/cm1eDgX9Vd5NmzUqd7cz2
        dELoqL0cYhirHojJKy5TLtP/mbOR1sg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-sgoQYwgSOqyfxY19qHDWhQ-1; Mon, 09 Dec 2019 09:21:14 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 242461005502;
        Mon,  9 Dec 2019 14:21:13 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-121.ams2.redhat.com [10.36.116.121])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AF01D60484;
        Mon,  9 Dec 2019 14:21:04 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 03/18] lib: Add WRITE_ONCE and READ_ONCE
 implementations in compiler.h
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, drjones@redhat.com,
        maz@kernel.org, andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com, Laurent Vivier <lvivier@redhat.com>,
        David Hildenbrand <david@redhat.com>
References: <20191128180418.6938-1-alexandru.elisei@arm.com>
 <20191128180418.6938-4-alexandru.elisei@arm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <df974420-5853-245a-c616-eeb7a54dd35e@redhat.com>
Date:   Mon, 9 Dec 2019 15:21:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191128180418.6938-4-alexandru.elisei@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: sgoQYwgSOqyfxY19qHDWhQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/11/2019 19.04, Alexandru Elisei wrote:
> Add the WRITE_ONCE and READ_ONCE macros which are used to prevent to

Duplicated "prevent to" - please remove one.

> prevent the compiler from optimizing a store or a load, respectively, into
> something else.

Could you please also add a note here in the commit message about the
kernel version that you used as a base? ... the file seems to have
changed quite a bit in the course of time, so I think it would be good
if we know the right base later.

 Thomas

