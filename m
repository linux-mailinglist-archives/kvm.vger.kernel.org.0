Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 710A410C40A
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 07:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfK1GiQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 01:38:16 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36207 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726436AbfK1GiQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Nov 2019 01:38:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574923096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EhFlF/ndy2ixO8rMiUeNrZqzqm2bi+mK6OkyJZAt2RM=;
        b=T3BGWuPPQGCXBNzpQSVRedo3KoaKgTzNbF9gh5aCo4r0U40dYJAI2cFlft/gIMYlFbutyB
        PuOd6y3abU1LcrcT8AcotPovertVh5Lw2JaZAZmj9Bz4hU1EjMHAuFIruO446u3C6Z5n86
        aIjX24bl0JUCE1m11O3yfc/TSJBeAq8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-MffJIWr1PHCji3rchShvGQ-1; Thu, 28 Nov 2019 01:38:14 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CF3601800D52
        for <kvm@vger.kernel.org>; Thu, 28 Nov 2019 06:38:13 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-114.ams2.redhat.com [10.36.116.114])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C274C60BE1;
        Thu, 28 Nov 2019 06:38:09 +0000 (UTC)
Subject: Re: [kvm-unit-tests Patch v1 2/2] x86: ioapic: Test physical and
 logical destination mode
To:     Nitesh Narayan Lal <nitesh@redhat.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, mtosatti@redhat.com
References: <1573044429-7390-1-git-send-email-nitesh@redhat.com>
 <1573044429-7390-3-git-send-email-nitesh@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <821842d1-2faf-074e-8639-80405efa26e4@redhat.com>
Date:   Thu, 28 Nov 2019 07:38:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1573044429-7390-3-git-send-email-nitesh@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: MffJIWr1PHCji3rchShvGQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/11/2019 13.47, Nitesh Narayan Lal wrote:
> This patch tests the physical destination mode by sending an
> interrupt to one of the vcpus and logical destination mode by
> sending an interrupt to more than one vcpus.
> 
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> ---
>   x86/ioapic.c | 65 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 65 insertions(+)

  Hi,

I think this patch likely broke the possibility to run the ioapic test 
under TCG (it was still working some weeks ago):

  https://gitlab.com/huth/kvm-unit-tests/-/jobs/363553211#L1815

Do you care about this test to be runnable under TCG, or shall I simply 
cook a patch to disable it in the gitlab CI?

  Thomas

