Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B84226EC0
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 21:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729431AbgGTTN4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 15:13:56 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:36879 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729237AbgGTTNz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Jul 2020 15:13:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595272434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=7fFPnduggHPhuqJ1v5ENhxy8NwpDEBZwSMSfxcE+hUY=;
        b=L/ZI+LmEGJNRRj4K5gUnOHlgO7rRMHj0Ya7VUWYfz9UVSt1Y6mwRyxBDIclK79MjLTyw4B
        K8QbSoIJcpBKZN/gFGkbRtRAbKUU/q0fOMh5UHuCG3zirwCMcz6bxhg90Md73ye5Wp0ylf
        cQjm1vGnkAo9vFORXjyYq/hy20ST+fk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-o8tXpO3YN7GMFRfm7b6TeQ-1; Mon, 20 Jul 2020 15:13:52 -0400
X-MC-Unique: o8tXpO3YN7GMFRfm7b6TeQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B273D107ACCA
        for <kvm@vger.kernel.org>; Mon, 20 Jul 2020 19:13:51 +0000 (UTC)
Received: from localhost.localdomain (ovpn-114-157.rdu2.redhat.com [10.10.114.157])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C16B7EF97
        for <kvm@vger.kernel.org>; Mon, 20 Jul 2020 19:13:51 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
Subject: question: kvm apic remote read register
To:     "kvm@vger.kernel.org >> kvm list" <kvm@vger.kernel.org>
Message-ID: <6d919c7f-1b70-e077-7eb8-2dc1e00e0827@redhat.com>
Date:   Mon, 20 Jul 2020 15:13:50 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Is does not appear that the APIC remote read register is available in 
KVM. Is that correct?

Thanks,

Cathy


