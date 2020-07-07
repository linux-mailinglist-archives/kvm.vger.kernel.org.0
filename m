Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F2A2176AF
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 20:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbgGGS1z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 14:27:55 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:36127 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728073AbgGGS1y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 14:27:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1594146473; x=1625682473;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=vnyWCGnhuREnmvMPpIcHJttkfy6CT39x1HReQgWnUS4=;
  b=qYiarEjSZqkJmPuU/x7sCvlJ82lT+spaazCZ79r4RJSXNk0JbnGXwfng
   aop/AK5zuTGbhTNEPpbx3HiHz5OnXFcQNWXX+gxUdfUCvNeSzG5Vf7Gpg
   fDUrhvWL/GFk2O8rBIK6S0/GLTVgz4NdiXOkIrMW0X8VF2XqgdQM4eqVK
   s=;
IronPort-SDR: bmG3CrN6wiKlVL+fOAW4EVbfKlzH9ul+Y0hDBSRHY68jiKP0cdcAKMtgDoMQbu8EhsAuKkLZLq
 fqWRcxxG1Ugw==
X-IronPort-AV: E=Sophos;i="5.75,324,1589241600"; 
   d="scan'208";a="49825902"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 07 Jul 2020 18:27:49 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com (Postfix) with ESMTPS id 5C87BA2553;
        Tue,  7 Jul 2020 18:27:48 +0000 (UTC)
Received: from EX13D16EUB001.ant.amazon.com (10.43.166.28) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 7 Jul 2020 18:27:47 +0000
Received: from 38f9d34ed3b1.ant.amazon.com (10.43.162.73) by
 EX13D16EUB001.ant.amazon.com (10.43.166.28) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 7 Jul 2020 18:27:39 +0000
Subject: Re: [PATCH v4 12/18] nitro_enclaves: Add logic for enclave start
To:     Alexander Graf <graf@amazon.de>, <linux-kernel@vger.kernel.org>
CC:     Anthony Liguori <aliguori@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Colm MacCarthaigh <colmmacc@amazon.com>,
        "Bjoern Doebel" <doebel@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "Frank van der Linden" <fllinden@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Martin Pohlack <mpohlack@amazon.de>,
        Matt Wilson <msw@amazon.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Balbir Singh <sblbir@amazon.com>,
        "Stefano Garzarella" <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stewart Smith <trawets@amazon.com>,
        Uwe Dannowski <uwed@amazon.de>, <kvm@vger.kernel.org>,
        <ne-devel-upstream@amazon.com>
References: <20200622200329.52996-1-andraprs@amazon.com>
 <20200622200329.52996-13-andraprs@amazon.com>
 <ff9b84e0-b4b5-fea4-e2e0-118d59e23784@amazon.de>
From:   "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Message-ID: <af789bbf-3a6e-fa5e-3602-b6d8f7f52e2c@amazon.com>
Date:   Tue, 7 Jul 2020 21:27:29 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ff9b84e0-b4b5-fea4-e2e0-118d59e23784@amazon.de>
Content-Language: en-US
X-Originating-IP: [10.43.162.73]
X-ClientProxiedBy: EX13D16UWC001.ant.amazon.com (10.43.162.117) To
 EX13D16EUB001.ant.amazon.com (10.43.166.28)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 06/07/2020 14:21, Alexander Graf wrote:
>
>
> On 22.06.20 22:03, Andra Paraschiv wrote:
>> After all the enclave resources are set, the enclave is ready for
>> beginning to run.
>>
>> Add ioctl command logic for starting an enclave after all its resources,
>> memory regions and CPUs, have been set.
>>
>> The enclave start information includes the local channel addressing -
>> vsock CID - and the flags associated with the enclave.
>>
>> Signed-off-by: Alexandru Vasile <lexnv@amazon.com>
>> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
>> ---
>> Changelog
>>
>> v3 -> v4
>>
>> * Use dev_err instead of custom NE log pattern.
>> * Update the naming for the ioctl command from metadata to info.
>> * Check for minimum enclave memory size.
>>
>> v2 -> v3
>>
>> * Remove the WARN_ON calls.
>> * Update static calls sanity checks.
>>
>> v1 -> v2
>>
>> * Add log pattern for NE.
>> * Check if enclave state is init when starting an enclave.
>> * Remove the BUG_ON calls.
>> ---
>> =A0 drivers/virt/nitro_enclaves/ne_misc_dev.c | 114 ++++++++++++++++++++=
++
>> =A0 1 file changed, 114 insertions(+)
>>
>> diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c =

>> b/drivers/virt/nitro_enclaves/ne_misc_dev.c
>> index 17ccb6cdbd75..d9794f327169 100644
>> --- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
>> +++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
>> @@ -703,6 +703,45 @@ static int =

>> ne_set_user_memory_region_ioctl(struct ne_enclave *ne_enclave,
>> =A0=A0=A0=A0=A0 return rc;
>> =A0 }
>> =A0 +/**
>> + * ne_start_enclave_ioctl - Trigger enclave start after the enclave =

>> resources,
>> + * such as memory and CPU, have been set.
>> + *
>> + * This function gets called with the ne_enclave mutex held.
>> + *
>> + * @ne_enclave: private data associated with the current enclave.
>> + * @enclave_start_info: enclave info that includes enclave cid and =

>> flags.
>> + *
>> + * @returns: 0 on success, negative return value on failure.
>> + */
>> +static int ne_start_enclave_ioctl(struct ne_enclave *ne_enclave,
>> +=A0=A0=A0 struct ne_enclave_start_info *enclave_start_info)
>> +{
>> +=A0=A0=A0 struct ne_pci_dev_cmd_reply cmd_reply =3D {};
>> +=A0=A0=A0 struct enclave_start_req enclave_start_req =3D {};
>> +=A0=A0=A0 int rc =3D -EINVAL;
>> +
>> +=A0=A0=A0 enclave_start_req.enclave_cid =3D enclave_start_info->enclave=
_cid;
>> +=A0=A0=A0 enclave_start_req.flags =3D enclave_start_info->flags;
>> +=A0=A0=A0 enclave_start_req.slot_uid =3D ne_enclave->slot_uid;
>
> I think it's easier to read if you do the initialization straight in =

> the variable declaation:
>
> =A0 struct enclave_start_req enclave_start_req =3D {
> =A0=A0=A0 .enclave_cid =3D enclave_start_info->cid,
> =A0=A0=A0 .flags =3D enclave_start_info->flags,
> =A0=A0=A0 .slot_uid =3D ne_enclave->slot_uid,
> =A0 };

Good point. In v5, I moved a couple of sanity checks from the ioctl =

switch case block in this function, so this would not apply wrt the =

updated codebase. But I'll keep this suggestion as reference for other =

cases.

>
>> +
>> +=A0=A0=A0 rc =3D ne_do_request(ne_enclave->pdev, ENCLAVE_START, =

>> &enclave_start_req,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sizeof(enclave_start_req), &=
cmd_reply,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sizeof(cmd_reply));
>> +=A0=A0=A0 if (rc < 0) {
>> +=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(ne_misc_dev.this_device,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "Error in enc=
lave start [rc=3D%d]\n", rc);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 return rc;
>> +=A0=A0=A0 }
>> +
>> +=A0=A0=A0 ne_enclave->state =3D NE_STATE_RUNNING;
>> +
>> +=A0=A0=A0 enclave_start_info->enclave_cid =3D cmd_reply.enclave_cid;
>> +
>> +=A0=A0=A0 return 0;
>> +}
>> +
>> =A0 static long ne_enclave_ioctl(struct file *file, unsigned int cmd,
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 unsigned long arg)
>> =A0 {
>> @@ -818,6 +857,81 @@ static long ne_enclave_ioctl(struct file *file, =

>> unsigned int cmd,
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 return rc;
>> =A0=A0=A0=A0=A0 }
>> =A0 +=A0=A0=A0 case NE_START_ENCLAVE: {
>> +=A0=A0=A0=A0=A0=A0=A0 struct ne_enclave_start_info enclave_start_info =
=3D {};
>> +=A0=A0=A0=A0=A0=A0=A0 int rc =3D -EINVAL;
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 if (copy_from_user(&enclave_start_info, (void *)a=
rg,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sizeof(enclave_s=
tart_info))) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(ne_misc_dev.this_=
device,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "=
Error in copy from user\n");
>
> No need to print anything here

Done.

>
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EFAULT;
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 mutex_lock(&ne_enclave->enclave_info_mutex);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 if (ne_enclave->state !=3D NE_STATE_INIT) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(ne_misc_dev.this_=
device,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "=
Enclave isn't in init state\n");
>> +
>> + mutex_unlock(&ne_enclave->enclave_info_mutex);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
>
> Can this be its own return value instead?

Yes, it should be and this would help with bubbling up to user space the =

reason of failure in more detail.

I started to define a set of NE error codes and update the failure paths =

(e.g. this one and the others mentioned below) to use those error codes.

>
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 if (!ne_enclave->nr_mem_regions) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(ne_misc_dev.this_=
device,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "=
Enclave has no mem regions\n");
>> +
>> + mutex_unlock(&ne_enclave->enclave_info_mutex);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -ENOMEM;
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 if (ne_enclave->mem_size < NE_MIN_ENCLAVE_MEM_SIZ=
E) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(ne_misc_dev.this_=
device,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "=
Enclave memory is less than %ld\n",
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 N=
E_MIN_ENCLAVE_MEM_SIZE);
>> +
>> + mutex_unlock(&ne_enclave->enclave_info_mutex);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -ENOMEM;
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 if (!ne_enclave->nr_vcpus) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(ne_misc_dev.this_=
device,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "=
Enclave has no vcpus\n");
>> +
>> + mutex_unlock(&ne_enclave->enclave_info_mutex);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
>
> Same here.
>
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 if (!cpumask_empty(ne_enclave->cpu_siblings)) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(ne_misc_dev.this_=
device,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "=
CPU siblings not used\n");
>> +
>> + mutex_unlock(&ne_enclave->enclave_info_mutex);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EINVAL;
>
> Same here.
>
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 rc =3D ne_start_enclave_ioctl(ne_enclave, &enclav=
e_start_info);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 mutex_unlock(&ne_enclave->enclave_info_mutex);
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 if (copy_to_user((void *)arg, &enclave_start_info,
>
> This needs to be __user void *, no?
>
>

Included "__user" in all the copy_from_user() / copy_to_user() calls.

Thank you.

Andra

>
>> + sizeof(enclave_start_info))) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev_err_ratelimited(ne_misc_dev.this_=
device,
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "=
Error in copy to user\n");
>> +
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return -EFAULT;
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +
>> +=A0=A0=A0=A0=A0=A0=A0 return rc;
>> +=A0=A0=A0 }
>> +
>> =A0=A0=A0=A0=A0 default:
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 return -ENOTTY;
>> =A0=A0=A0=A0=A0 }
>>




Amazon Development Center (Romania) S.R.L. registered office: 27A Sf. Lazar=
 Street, UBC5, floor 2, Iasi, Iasi County, 700045, Romania. Registered in R=
omania. Registration number J22/2621/2005.

