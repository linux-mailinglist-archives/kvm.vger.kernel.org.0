Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735AD3CD3FC
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 13:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236292AbhGSKzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 06:55:20 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17910 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235440AbhGSKzT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Jul 2021 06:55:19 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16JBZf7n031116;
        Mon, 19 Jul 2021 07:35:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=zkxwCRqlJCStSrqFy2KfmPwNYzFYes6pCW6qan7Nht8=;
 b=Vz7nEhbvmF7dRJLDVAVxFSKEZ2bpv/ehi9EtCzyIU8G+YEauaUZ0dPiIeKmPVkm4Kkft
 oDDxA6LYrNffvR/wPIvxKM7mydfHjiIvTgwfyh/K3Kkax6SV4W3wClDwoInKb4vXEG+Y
 CYx7SUyEPrOjD3Eb7LelsOq3PGetVsnOPHSizFtwwYwPEsxJIgfkNLfNb8mxPWopVykn
 ylNe361Zh9kxIZAzNDpi8gjLIft7RPIdEMAhFNdhfrCieRl/xspFhMHZjrGgYn+HwBau
 1EP/K9IaDEKFU+sGF1IyjGxdLktvy+3V+Fz1f3gWvPP9gc2d4SjBIzV7ru7OiZ8bhs3y YA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39w7yksn1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jul 2021 07:35:50 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16JBZnL4031875;
        Mon, 19 Jul 2021 07:35:49 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39w7yksmqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jul 2021 07:35:49 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16JBStUW032161;
        Mon, 19 Jul 2021 11:35:27 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04wdc.us.ibm.com with ESMTP id 39upua404s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jul 2021 11:35:27 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16JBZQH234406868
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jul 2021 11:35:26 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9897E124080;
        Mon, 19 Jul 2021 11:35:26 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF762124085;
        Mon, 19 Jul 2021 11:35:23 +0000 (GMT)
Received: from [9.65.195.237] (unknown [9.65.195.237])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 19 Jul 2021 11:35:23 +0000 (GMT)
Subject: Re: [RFC PATCH 1/6] linux-header: add the SNP specific command
To:     Brijesh Singh <brijesh.singh@amd.com>, qemu-devel@nongnu.org
Cc:     Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>
References: <20210709215550.32496-1-brijesh.singh@amd.com>
 <20210709215550.32496-2-brijesh.singh@amd.com>
From:   Dov Murik <dovmurik@linux.ibm.com>
Message-ID: <cb98088a-a347-d921-0f1d-d271d740c649@linux.ibm.com>
Date:   Mon, 19 Jul 2021 14:35:22 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210709215550.32496-2-brijesh.singh@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6L3N1rfCnGKkxc3gRfZwqJiyBth-lb6d
X-Proofpoint-ORIG-GUID: usHTDc4mIz38WHl1Ou2wypMNZjB5nlJw
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-19_05:2021-07-16,2021-07-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 malwarescore=0 impostorscore=0 mlxscore=0 phishscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107190065
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Brijesh,

On 10/07/2021 0:55, Brijesh Singh wrote:
> Sync the kvm.h with the kernel to include the SNP specific commands.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  linux-headers/linux/kvm.h | 47 +++++++++++++++++++++++++++++++++++++++


What about psp-sev.h ? I see that kernel patch "[PATCH Part2 RFC v4
11/40] crypto:ccp: Define the SEV-SNP commands" adds some new PSP return
codes.

The QEMU user-friendly string list sev_fw_errlist (in sev.c) should be
updated accordingly.

-Dov

