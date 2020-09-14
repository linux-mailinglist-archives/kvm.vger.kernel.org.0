Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32234269172
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 18:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgINQZh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 12:25:37 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58243 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726349AbgINQYw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Sep 2020 12:24:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600100690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xef7Kk4IuwAVAYdz+twwXuQ+WpMqbHkK2OBlguMvPCA=;
        b=fRJYSnx+9fOtIevIVfyBuVq5QO4wU0NDQDyaJ5IfC+zJ4HFMqz55xATuZRTqyswjPjBgPZ
        YnfsBkfXe/1LuVVX7Rv4W1jquXn8pNCs3Twfw9zqsohndEvn8sJW8oGHr/xtQuWIMK8U61
        KEnl1Mw1c17t5y/ZUEq+n5llP5BJiTA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-MgC-1ydvMpOSNtuIqUy37w-1; Mon, 14 Sep 2020 12:24:46 -0400
X-MC-Unique: MgC-1ydvMpOSNtuIqUy37w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0EE461084D60;
        Mon, 14 Sep 2020 16:24:45 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-134.ams2.redhat.com [10.36.112.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C3C8B34687;
        Mon, 14 Sep 2020 16:24:37 +0000 (UTC)
Subject: Re: [kvm-unit-tests GIT PULL 0/3] s390x skrf and ultravisor patches
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.vnet.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
References: <20200901091823.14477-1-frankja@linux.ibm.com>
 <34c80837-208f-bb29-cb0b-b9029fdad29d@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <71b38000-70ee-f45a-b80d-95f42dbcc497@redhat.com>
Date:   Mon, 14 Sep 2020 18:24:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <34c80837-208f-bb29-cb0b-b9029fdad29d@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/09/2020 19.41, Paolo Bonzini wrote:
> On 01/09/20 11:18, Janosch Frank wrote:
>>   git@gitlab.com:frankja/kvm-unit-tests.git tags/s390x-2020-01-09
> 
> Pulled, thanks.
> 
> (Yes, I am alive).

 Hi Paolo,

I don't see the patches in the master branch - could you please push
them to the repo?

 Thanks,
  Thomas

