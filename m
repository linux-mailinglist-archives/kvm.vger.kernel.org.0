Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9F21EEE46
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 01:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbgFDXbe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 19:31:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62924 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725920AbgFDXbe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Jun 2020 19:31:34 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 054N0WWo141828;
        Thu, 4 Jun 2020 19:31:09 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31f9dqsuf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 19:31:09 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 054N2x3E151416;
        Thu, 4 Jun 2020 19:31:08 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31f9dqsuey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 19:31:08 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 054NV6tH001464;
        Thu, 4 Jun 2020 23:31:08 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03wdc.us.ibm.com with ESMTP id 31bf48yq5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Jun 2020 23:31:08 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 054NV5KO30212604
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Jun 2020 23:31:05 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C249BBE051;
        Thu,  4 Jun 2020 23:31:06 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A905FBE054;
        Thu,  4 Jun 2020 23:31:02 +0000 (GMT)
Received: from morokweng.localdomain (unknown [9.160.104.193])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Thu,  4 Jun 2020 23:31:02 +0000 (GMT)
References: <20200521034304.340040-1-david@gibson.dropbear.id.au> <87tuzr5ts5.fsf@morokweng.localdomain> <20200604062124.GG228651@umbus.fritz.box> <87r1uu1opr.fsf@morokweng.localdomain> <dc56f533-f095-c0c0-0fc6-d4c5af5e51a7@redhat.com>
User-agent: mu4e 1.2.0; emacs 26.3
From:   Thiago Jung Bauermann <bauerman@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>, qemu-ppc@nongnu.org,
        qemu-devel@nongnu.org, brijesh.singh@amd.com,
        frankja@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [RFC v2 00/18] Refactor configuration of guest memory protection
In-reply-to: <dc56f533-f095-c0c0-0fc6-d4c5af5e51a7@redhat.com>
Date:   Thu, 04 Jun 2020 20:30:58 -0300
Message-ID: <87pnae1k99.fsf@morokweng.localdomain>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-04_13:2020-06-04,2020-06-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 clxscore=1015 lowpriorityscore=0 phishscore=0 priorityscore=1501
 mlxscore=0 spamscore=0 suspectscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006040157
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Paolo Bonzini <pbonzini@redhat.com> writes:

> On 04/06/20 23:54, Thiago Jung Bauermann wrote:
>> QEMU could always create a PEF object, and if the command line defines
>> one, it will correspond to it. And if the command line doesn't define one,
>> then it would also work because the PEF object is already there.
>
> How would you start a non-protected VM?

In the case of POWER PEF even with the machine property and the
pef-guest object it's not guaranteed that the VM will be protected. They
allow the possibility of the VM being protected. The decision lies with
the guest. The Linux kernel will request being moved to "secure memory"
when the `svm=on` parameter is passed in the kernel command line.

To start a VM that doesn't have the possibility of being protected, one
would simply not use the guest-memory-protection property (or
host-trust-limitation, if that ends up being its name). Regardless of
whether there's a pef-guest object.

Sorry if the above is pedantic. I just want to make sure we're
communicating clearly.

> Currently it's the "-machine"
> property that decides that, and the argument requires an id
> corresponding to "-object".

If there's only one object, there's no need to specify its id.

I have the feeling I didn't understand your point. I hope these answers
clarify what I'm suggesting.

--
Thiago Jung Bauermann
IBM Linux Technology Center
