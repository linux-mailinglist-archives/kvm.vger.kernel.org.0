Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40C8052A09E
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 13:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344288AbiEQLma (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 07:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbiEQLm0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 07:42:26 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A4627FFE;
        Tue, 17 May 2022 04:42:26 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HBLsdO011919;
        Tue, 17 May 2022 11:42:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=KntiIZ5OG8c7GGkc3zAW0gbb1bfsok+P225v+3cJ/+I=;
 b=sVVsJEubygIR/2Rm97qxx6Ne5sgnLVbShhv96v5+jymAslen+FWXf1HVNZP8vLYoKqIR
 hxGwaosUTb31MJGesL7rf/W7EX522zTY7yV+hF354p0cmablzxeR6cpYVO4PF6hxrMU1
 kOQH7P492jOhHZkWlDYEyZm9yef6Uy+OAbP3giCLmoKrP5qKHcQ06cDrLPhCcc/n0xFX
 clMDRCyLImXO8EwoLTqBw+ObRHfgJ0P7vNpL+AquBmXV8iofzpsDGa2jrzu2yy+LRKUa
 S5+lK4utemymCqUBusi93Mdi0J7rfCugw++fvP8WXsfri+ssZ0UGsjd9Pu7ySOqYysY9 nw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4artgd4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 11:42:25 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HBHvj1019603;
        Tue, 17 May 2022 11:37:22 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3g23pjc4pp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 11:37:22 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HBbJ5G47907176
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 11:37:19 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8FF03A405F;
        Tue, 17 May 2022 11:37:19 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6079DA405B;
        Tue, 17 May 2022 11:37:19 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.40])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 11:37:19 +0000 (GMT)
Date:   Tue, 17 May 2022 13:13:49 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@linux.ibm.com
Subject: Re: [PATCH v5 09/10] Documentation: virt: Protected virtual machine
 dumps
Message-ID: <20220517131349.31c66921@p-imbrenda>
In-Reply-To: <20220516090817.1110090-10-frankja@linux.ibm.com>
References: <20220516090817.1110090-1-frankja@linux.ibm.com>
        <20220516090817.1110090-10-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZORdCfjMc-Sm9vDNAGPk-0FAD7W7T4YY
X-Proofpoint-GUID: ZORdCfjMc-Sm9vDNAGPk-0FAD7W7T4YY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_02,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 bulkscore=0 suspectscore=0 impostorscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 May 2022 09:08:16 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Let's add a documentation file which describes the dump process. Since
> we only copy the UV dump data from the UV to userspace we'll not go
> into detail here and let the party which processes the data describe
> its structure.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  Documentation/virt/kvm/s390/index.rst        |  1 +
>  Documentation/virt/kvm/s390/s390-pv-dump.rst | 64 ++++++++++++++++++++
>  2 files changed, 65 insertions(+)
>  create mode 100644 Documentation/virt/kvm/s390/s390-pv-dump.rst
> 
> diff --git a/Documentation/virt/kvm/s390/index.rst b/Documentation/virt/kvm/s390/index.rst
> index 605f488f0cc5..44ec9ab14b59 100644
> --- a/Documentation/virt/kvm/s390/index.rst
> +++ b/Documentation/virt/kvm/s390/index.rst
> @@ -10,3 +10,4 @@ KVM for s390 systems
>     s390-diag
>     s390-pv
>     s390-pv-boot
> +   s390-pv-dump
> diff --git a/Documentation/virt/kvm/s390/s390-pv-dump.rst b/Documentation/virt/kvm/s390/s390-pv-dump.rst
> new file mode 100644
> index 000000000000..e542f06048f3
> --- /dev/null
> +++ b/Documentation/virt/kvm/s390/s390-pv-dump.rst
> @@ -0,0 +1,64 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +===========================================
> +s390 (IBM Z) Protected Virtualization dumps
> +===========================================
> +
> +Summary
> +-------
> +
> +Dumping a VM is an essential tool for debugging problems inside
> +it. This is especially true when a protected VM runs into trouble as
> +there's no way to access its memory and registers from the outside
> +while it's running.
> +
> +However when dumping a protected VM we need to maintain its
> +confidentiality until the dump is in the hands of the VM owner who
> +should be the only one capable of analysing it.
> +
> +The confidentiality of the VM dump is ensured by the Ultravisor who
> +provides an interface to KVM over which encrypted CPU and memory data
> +can be requested. The encryption is based on the Customer
> +Communication Key which is the key that's used to encrypt VM data in a
> +way that the customer is able to decrypt.
> +
> +
> +Dump process
> +------------
> +
> +A dump is done in 3 steps:
> +
> +**Initiation**
> +
> +This step initializes the dump process, generates cryptographic seeds
> +and extracts dump keys with which the VM dump data will be encrypted.
> +
> +**Data gathering**
> +
> +Currently there are two types of data that can be gathered from a VM:
> +the memory and the vcpu state.
> +
> +The vcpu state contains all the important registers, general, floating
> +point, vector, control and tod/timers of a vcpu. The vcpu dump can
> +contain incomplete data if a vcpu is dumped while an instruction is
> +emulated with help of the hypervisor. This is indicated by a flag bit
> +in the dump data. For the same reason it is very important to not only
> +write out the encrypted vcpu state, but also the unencrypted state
> +from the hypervisor.
> +
> +The memory state is further divided into the encrypted memory and its
> +metadata comprised of the encryption tweaks and status flags. The
> +encrypted memory can simply be read once it has been exported. The
> +time of the export does not matter as no re-encryption is
> +needed. Memory that has been swapped out and hence was exported can be
> +read from the swap and written to the dump target without need for any
> +special actions.
> +
> +The tweaks / status flags for the exported pages need to be requested
> +from the Ultravisor.
> +
> +**Finalization**
> +
> +The finalization step will provide the data needed to be able to
> +decrypt the vcpu and memory data and end the dump process. When this
> +step completes successfully a new dump initiation can be started.

