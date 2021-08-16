Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 091933ED984
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 17:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236384AbhHPPIK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 11:08:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15866 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232809AbhHPPIH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Aug 2021 11:08:07 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17GF2oWa081059;
        Mon, 16 Aug 2021 11:07:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : references :
 subject : cc : from : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=pp1;
 bh=ElC+X0ZF7nOSBN3bwaWcxMyEUwlqLEcqHdvchOPubOY=;
 b=KdEaNaKqHJZ7L72numDh6nNH4HKmQ3q/YhPj3MaPT62pD82gZoRLlekYpEbVtZ10SJ+9
 Jigq9SmvJAJic+bK1sJ8D1Cy+iBSHacOrYal4dc7jswQpWdlwEqrOQy+jlTSsrZtl2/D
 jVoZnKMGx7YLjakILDgzCC1fWcdduEXYYXZwZbYQ6cIWh2W7wm+9QQhDbb9/pka1UY1j
 OzOYGEy8yVGQOkvnXJRl1RrA+QKAhtJrxwJWB17qA5Uc/grNZ/vKDia5o77UlDE2xVq5
 u4vw/bK040IAwzu/eGK1s2EjsNktDvvueojPzMYQnXNGgAxzDpJibfIorivL146kI4Ls eQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aetvv30ne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 11:07:28 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17GF3HAm083773;
        Mon, 16 Aug 2021 11:07:27 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3aetvv30mf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 11:07:27 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17GF4Mmv021180;
        Mon, 16 Aug 2021 15:07:25 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma03dal.us.ibm.com with ESMTP id 3ae5fc369f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Aug 2021 15:07:25 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17GF7OSF51380648
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 15:07:24 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 725CFAE060;
        Mon, 16 Aug 2021 15:07:24 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 16866AE064;
        Mon, 16 Aug 2021 15:07:24 +0000 (GMT)
Received: from Tobins-MacBook-Pro-2.local (unknown [9.160.147.42])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 16 Aug 2021 15:07:23 +0000 (GMT)
To:     ashish.kalra@amd.com
References: 
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
Cc:     qemu-devel@nongnu.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>, ehabkost@redhat.com,
        mst@redhat.com, richard.henderson@linaro.org,
        James Bottomley <jejb@linux.ibm.com>,
        dovmurik@linux.vnet.ibm.com, Hubertus Franke <frankeh@us.ibm.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        kvm list <kvm@vger.kernel.org>
From:   Tobin Feldman-Fitzthum <tobin@linux.ibm.com>
Message-ID: <340f9f9f-cc90-1b02-83e4-54a84d49667d@linux.ibm.com>
Date:   Mon, 16 Aug 2021 11:07:23 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IdJ7JyKReMa-6bN4Sh9YMvhl2epsGmag
X-Proofpoint-ORIG-GUID: 68s1uD_LTCeEcLVD8xpa5WcH3xOP0jGR
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-16_05:2021-08-16,2021-08-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=880 bulkscore=0 clxscore=1011
 lowpriorityscore=0 spamscore=0 adultscore=0 suspectscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108160096
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 16 at 10:44 AM Ashish Kalra wrote:

 > I am not sure if we really don't need QEMU's MMIO logic, I think that 
once the>
 > mirror VM starts booting and running the UEFI code, it might be only 
during
 > the PEI or DXE phase where it will start actually running the MH code,
 > so mirror VM probably still need to handles KVM_EXIT_IO when SEC 
phase does I/O,
 > I can see PIC accesses and Debug Agent initialization stuff in SEC 
startup code.

The migration handler prototype that we are releasing in the near future 
does not use the SEC or PEI phases in the mirror. We have some support 
code that runs in the main VM and sets up the migration handler entry 
point. QEMU starts the mirror pointing to this entry point, which does 
some more setup (like switching to long mode) and jumps to the migration 
handler.

-Tobin

 > Addtionally this still requires CPUState{..} structure and the backing
 > "X86CPU" structure, for example, as part of kvm_arch_post_run() to get
 > the MemTxAttrs needed by kvm_handle_io().

 > Thanks,
 > Ashish

