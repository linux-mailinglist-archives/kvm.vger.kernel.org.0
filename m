Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 352795F554
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 11:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbfGDJR2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jul 2019 05:17:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57378 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727196AbfGDJR2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 05:17:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x649EMsa081959;
        Thu, 4 Jul 2019 09:16:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=xp3cbvS9v8hYznHo4qbu7l3B3aVHsVMqtVioUPtKRSc=;
 b=KKj54mdD64Z1FlD+/ydYmMOtj76k1C2kVnF51cbk+yL5RVqkbSSYI1/z+BSKQQ9OShCl
 ghPGqxD2l2TVQvMCS5K8yMUHem6LO2XUF82iahhaeYJP9MqF4PBbX2YgfOTUVeMuxy/x
 +16PqxcNZpuIsioCTHHA645AeaJx6hIbUbkHOVBYdGvvzIzXpZMEgGqUpHGl9pbkscSr
 3u7Sn1ArL4tBVLJX02n5hpOz6zAisFIF7AWNpz2uv83yuRZSDyeB5j2bS6LmD8Unx76R
 p7WGinG9c+y1Q9nqRkRD/uP0uU2w0hUtG8kQkwGHktY22rJmmvPIHp07FwDWpM6R8df0 Sg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2te5tbwvfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Jul 2019 09:16:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x649CmVN059451;
        Thu, 4 Jul 2019 09:16:40 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2th9ebvmks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Jul 2019 09:16:40 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x649GbPL006616;
        Thu, 4 Jul 2019 09:16:39 GMT
Received: from [10.175.206.207] (/10.175.206.207)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 04 Jul 2019 02:16:36 -0700
Subject: Re: [patch 1/5] add cpuidle-haltpoll driver
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm-devel <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <kernellwp@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Raslan KarimAllah <karahmed@amazon.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-pm@vger.kernel.org
References: <20190703235124.783034907@amt.cnet>
 <20190703235828.340866829@amt.cnet>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <db95f834-0307-813a-323c-c5e23c90e3f5@oracle.com>
Date:   Thu, 4 Jul 2019 10:16:47 +0100
MIME-Version: 1.0
In-Reply-To: <20190703235828.340866829@amt.cnet>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9307 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907040121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9307 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907040121
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/4/19 12:51 AM, Marcelo Tosatti wrote:
> +++ linux-2.6-newcpuidle.git/drivers/cpuidle/cpuidle-haltpoll.c
> @@ -0,0 +1,69 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * cpuidle driver for haltpoll governor.
> + *
> + * Copyright 2019 Red Hat, Inc. and/or its affiliates.
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2.  See
> + * the COPYING file in the top-level directory.
> + *
> + * Authors: Marcelo Tosatti <mtosatti@redhat.com>
> + */
> +
> +#include <linux/init.h>
> +#include <linux/cpuidle.h>
> +#include <linux/module.h>
> +#include <linux/sched/idle.h>
> +#include <linux/kvm_para.h>
> +
> +static int default_enter_idle(struct cpuidle_device *dev,
> +			      struct cpuidle_driver *drv, int index)
> +{
> +	if (current_clr_polling_and_test()) {
> +		local_irq_enable();
> +		return index;
> +	}
> +	default_idle();
> +	return index;
> +}
> +
> +static struct cpuidle_driver haltpoll_driver = {
> +	.name = "haltpoll",
> +	.owner = THIS_MODULE,
> +	.states = {
> +		{ /* entry 0 is for polling */ },
> +		{
> +			.enter			= default_enter_idle,
> +			.exit_latency		= 1,
> +			.target_residency	= 1,
> +			.power_usage		= -1,
> +			.name			= "haltpoll idle",
> +			.desc			= "default architecture idle",
> +		},
> +	},
> +	.safe_state_index = 0,
> +	.state_count = 2,
> +};
> +
> +static int __init haltpoll_init(void)
> +{
> +	struct cpuidle_driver *drv = &haltpoll_driver;
> +
> +	cpuidle_poll_state_init(drv);
> +
> +	if (!kvm_para_available())
> +		return 0;
> +

Isn't this meant to return -ENODEV value if the module is meant to not load?

Also this check should probably be placed before initializing the poll state,
provided poll state isn't used anyways if you're not a kvm guest.

	Joao
