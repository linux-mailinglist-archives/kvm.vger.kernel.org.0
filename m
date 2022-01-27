Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F5F49E129
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 12:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240493AbiA0LeV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 06:34:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46392 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233257AbiA0LeU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Jan 2022 06:34:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643283260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eRamBbpT311kNANsc1md2YaaDekckDODpPsktpFoI4o=;
        b=gLEZDyl1erjwzvevZF/qCjm7dRWMcQnMoOFvsWX5jcANs/v7jioGwrCNf5nkd8smZXwMsZ
        HvpFOk/0PbYj6UrDp1TjdOzpRcDAGaJ5JAGmfukdUpyV5Hyg9MOiy3Z7WMDmNQRhEqcLJa
        3L+1WiNd4WP9gb5BtZc+tEhb4nmu1/4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-204-1B5XRkiPNx2HK5VPNX03DQ-1; Thu, 27 Jan 2022 06:34:18 -0500
X-MC-Unique: 1B5XRkiPNx2HK5VPNX03DQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A66DA1091DA2;
        Thu, 27 Jan 2022 11:34:17 +0000 (UTC)
Received: from blackfin.pond.sub.org (ovpn-112-7.ams2.redhat.com [10.36.112.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DBB8D76110;
        Thu, 27 Jan 2022 11:34:14 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id 47842113864A; Thu, 27 Jan 2022 12:34:13 +0100 (CET)
From:   Markus Armbruster <armbru@redhat.com>
To:     Juan Quintela <quintela@redhat.com>
Cc:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org,
        Mirela Grujic <mirela.grujic@greensocs.com>
Subject: Re: KVM call minutes for 2022-01-25
References: <87k0enrcr0.fsf@secure.mitica> <87a6fjrco3.fsf@secure.mitica>
Date:   Thu, 27 Jan 2022 12:34:13 +0100
In-Reply-To: <87a6fjrco3.fsf@secure.mitica> (Juan Quintela's message of "Tue,
        25 Jan 2022 17:41:00 +0100")
Message-ID: <87v8y5s98q.fsf@dusky.pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Juan Quintela <quintela@redhat.com> writes:

> Juan Quintela <quintela@redhat.com> wrote:
>> Hi
>>
>> Today we have the KVM devel call.  We discussed how to create machines
>> from QMP without needing to recompile QEMU.
>>
>>
>> Three different problems:
>> - startup QMP (*)
>>   not discussed today
>> - one binary or two
>>   not discussed today
>> - being able to create machines dynamically.
>>   everybody agrees that we want this. Problem is how.
>> - current greensocs approach
>> - interested for all architectures, they need a couple of them
>>
>> what greensocs have:
>> - python program that is able to read a blob that have a device tree from the blob
>> - basically the machine type is empty and is configured from there
>> - 100 machines around 400 devices models
>> - Need to do the configuration before the machine construction happens
>> - different hotplug/coldplug
>> - How to describe devices that have multiple connections

Nice demo, by the way!  I assume you're going to post patches.  Feel
free to post as RFC when the work isn't ready for merge, but could use
review, or could make our discussions more productive.

[...]

