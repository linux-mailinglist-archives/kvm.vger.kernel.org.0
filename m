Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA474DE25
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 02:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbfFUAnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 20:43:02 -0400
Received: from cmta17.telus.net ([209.171.16.90]:37397 "EHLO cmta17.telus.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725869AbfFUAnC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 20:43:02 -0400
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Jun 2019 20:43:00 EDT
Received: from dougxps ([173.180.45.4])
        by cmsmtp with SMTP
        id e7VvhxIxrzEP4e7VwhkFhQ; Thu, 20 Jun 2019 18:34:52 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=telus.net; s=neo;
        t=1561077292; bh=urU0428ZFEGLWgzuNZY1P09IlsyrjE5qQ6gxZy1X1Bc=;
        h=From:To:Cc:References:In-Reply-To:Subject:Date;
        b=7GIAaQuOjzmNXnsQ0ZD9AB1nqZtvqeZCR82ADD1sDk/Df2xWyvS6mh0Y/wm7wT/ct
         22ckRJZQN2PQTOLmzbmEw/F+E+zhdHIO+6yAIwmcUXLLl089X5ga40X9M9A0tyTqdD
         dlWR6HTUpY48w35MXSo261g9DdXYvHzUV+KYSK8DoeiTurRKuyN/5e5GwQw5Ul0aT7
         NbjtUauu7aMRGAjHGzfxQd98LRxA3lJDCuhU6wMNMYYHi5a7u5Kwn2gYCpecgMWo4F
         pb0Ns9w6ox8kumsY6xS/veHHTKLONmCHIgJBUSHWa3yzQ8BZlm7rMUdJJmQRlMeW5d
         bS6s90TOLTojA==
X-Telus-Authed: none
X-Authority-Analysis: v=2.3 cv=cYmsUULM c=1 sm=1 tr=0
 a=zJWegnE7BH9C0Gl4FFgQyA==:117 a=zJWegnE7BH9C0Gl4FFgQyA==:17
 a=Pyq9K9CWowscuQLKlpiwfMBGOR0=:19 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19
 a=kj9zAlcOel0A:10 a=5RwkHVgcu25qzxWHrfAA:9 a=CjuIK1q_8ugA:10
From:   "Doug Smythies" <dsmythies@telus.net>
To:     "'Marcelo Tosatti'" <mtosatti@redhat.com>
Cc:     "'Paolo Bonzini'" <pbonzini@redhat.com>,
        "'Radim Krcmar'" <rkrcmar@redhat.com>,
        "'Andrea Arcangeli'" <aarcange@redhat.com>,
        "'Rafael J. Wysocki'" <rafael.j.wysocki@intel.com>,
        "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Wanpeng Li'" <kernellwp@gmail.com>,
        "'Konrad Rzeszutek Wilk'" <konrad.wilk@oracle.com>,
        "'Raslan KarimAllah'" <karahmed@amazon.de>,
        "'Boris Ostrovsky'" <boris.ostrovsky@oracle.com>,
        "'Ankur Arora'" <ankur.a.arora@oracle.com>,
        "'Christian Borntraeger'" <borntraeger@de.ibm.com>,
        <linux-pm@vger.kernel.org>, "'kvm-devel'" <kvm@vger.kernel.org>
References: <20190613224532.949768676@redhat.com> <20190613225023.011025297@redhat.com>
In-Reply-To: <20190613225023.011025297@redhat.com>
Subject: RE: [patch 3/5] cpuidle: add haltpoll governor
Date:   Thu, 20 Jun 2019 17:34:46 -0700
Message-ID: <002e01d527c9$23be6e10$6b3b4a30$@net>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Content-Language: en-ca
Thread-Index: AdUiOxeAsWfAsrU3S6OogxwSC2p7RgFjChIQ
X-CMAE-Envelope: MS4wfGMFGMbra82X56Zpq6ar+KffH0WljB7vnHIQBngvBIW04413e/RgxdNEDutTVsRSxdl8FnLIHuUspQYTWDS9TZV8/SiPHoeENxLhRTIG0IA8PQ5eg92q
 xiYOszYfBw6JeRkBuGTZduP9w++B16cuJvdGnZf0Fxkd3lw6CDCCvMgpBMO5rKdu131CjC7uBoH7K7SALy0mSDusWJEB5v6zbSMi9wEu0nvhW2mp8QNk3ntF
 0dPbnroZXPmD6zq09wzGXGfeE2C6ZQmDDzirg3OYlbu1F3P0ZmIbVbQpMcBEjVA9obm6TPbDl4isTO1UmNb0JcfJiiZy8kq4RC0naQgjJwRVmt9yCmmaElG6
 IkId6qvs+dtpEjKYDjsonVpdzLXLEjJS89Z27GYga9dcTlLFGQCdtM8E7leseeA1VlrZcym6Hc6rI7T6XUp1VGxG1iVkKZ9Gx3yKzqc1I2FFs3bhwuG6G+aM
 9GB9e9h9DfG2H7Tm380RXAP+InTF3gzipMK+RuHN+A32kRcQotGo4tKX6ODsvcNqSS/c6wzZuoALQpa2EIUhMD5FokA7EBOyNuhklBaIkUB6api0gL8IergR
 vcY=
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I tried your patch set, but only to check
that they didn't cause any regression for situations
where idle state 0 (Poll) is used a lot (teo governor).

They didn't (my testing was not thorough).

I do not know if the below matters or not.

On 2019.06.13 15:46 Marcelo Tosatti wrote:

... [snip] ...

> Index: linux-2.6.git/Documentation/virtual/guest-halt-polling.txt
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6.git/Documentation/virtual/guest-halt-polling.txt	2019-06-13 18:16:22.414262777 -0400
> @@ -0,0 +1,79 @@
> +Guest halt polling
> +==================
> +
> +The cpuidle_haltpoll driver, with the haltpoll governor, allows
> +the guest vcpus to poll for a specified amount of time before
> +halting.
> +This provides the following benefits to host side polling:
> +
> +	1) The POLL flag is set while polling is performed, which allows
> +	   a remote vCPU to avoid sending an IPI (and the associated
> + 	   cost of handling the IPI) when performing a wakeup.
   ^
   |_ While applying the patches, git complains about this space character before the TAB.

It also complains about a few patches with a blank line before EOF.

... Doug


