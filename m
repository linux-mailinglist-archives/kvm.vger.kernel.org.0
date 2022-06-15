Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F157554C734
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 13:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346600AbiFOLNs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 07:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243558AbiFOLN1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 07:13:27 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9513B03D;
        Wed, 15 Jun 2022 04:13:26 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25FAbsfg011334;
        Wed, 15 Jun 2022 11:13:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=csDdvx+atFc4IFUFG//B+LyG9gsn7+/OKEPNkF2FqKY=;
 b=rG/hytbw3rgwFey1iYCi9ugxMKu6O+cfOIYkRRBJEEF9Q2iyusXSqIh46r2QvXrzNFDr
 SBv+ln7kLbDWkX9euge/nDEo5sHhFe9/MK5KH+ztz7Vts1YtSk4INimnheE8FWcH84Pz
 AxmICbtF8omtTxboMwTuKBuk1+MtybDuBRVzqcuCuWLVesBbof3Zz1DZT4Q3D3E/B+Y6
 TjwwTQhQVCjUqRwiw0ojkJTxXrFJsom0k1t4sxJtTM1X56Yw2chLjIaJVlbBongK9Oex
 0rL4xIEEr8UjEIMfY8bF8BpHmG9E1uPabwLt21L/VeSzgcbMDz2qABR2Y6XOEVxV6UMb oQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gpr3g4efr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jun 2022 11:13:25 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25FAh6UM024131;
        Wed, 15 Jun 2022 11:13:24 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gpr3g4ef2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jun 2022 11:13:24 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25FB6x7f015900;
        Wed, 15 Jun 2022 11:13:22 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3gmjp94ds4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 15 Jun 2022 11:13:22 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25FBDJqW19857878
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jun 2022 11:13:19 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 599F252050;
        Wed, 15 Jun 2022 11:13:19 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.67])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9006C5204E;
        Wed, 15 Jun 2022 11:13:18 +0000 (GMT)
Date:   Wed, 15 Jun 2022 13:13:16 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [PATCH v11 14/19] KVM: s390: pv: cleanup leftover protected VMs
 if needed
Message-ID: <20220615131316.6336eb6d@p-imbrenda>
In-Reply-To: <44b2b227-9757-b7a2-41a0-cbea0e2bbbdc@linux.ibm.com>
References: <20220603065645.10019-1-imbrenda@linux.ibm.com>
        <20220603065645.10019-15-imbrenda@linux.ibm.com>
        <0a13397a-86e0-7c25-0044-7a5733f61730@linux.ibm.com>
        <20220615121916.77b039af@p-imbrenda>
        <44b2b227-9757-b7a2-41a0-cbea0e2bbbdc@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: juiPRvCgQW3jYTedCvH_lGwbhVZ6ZJma
X-Proofpoint-GUID: HL0Hle144Ba_E4Z-h_dv5ye5nfshGXKO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-15_03,2022-06-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015
 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=968 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206150043
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 15 Jun 2022 12:57:39 +0200
Janosch Frank <frankja@linux.ibm.com> wrote:

[...]

> >> I think we should switch this patch and the next one and add this struct
> >> to the next patch. The list work below makes more sense once the next
> >> patch has been read.  
> > 
> > but the next patch will leave leftovers in some circumstances, and
> > those won't be cleaned up without this patch.
> > 
> > having this patch first means that when the next patch is applied, the
> > leftovers are already taken care of  
> 
> Then I opt for squashing the patch.
> 
> Without the next patch prepared_for_async_deinit will always be NULL and 
> this code is completely unneeded, no?

correct. I had split them to make them smaller and easier to review

I will squash them if you think it's better

> 
> >   
> >>>    static void kvm_s390_clear_pv_state(struct kvm *kvm)
> >>>    {
> >>>    	kvm->arch.pv.handle = 0;
> >>> @@ -158,23 +171,88 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
> >>>    	return -ENOMEM;
> >>>    }
> >>>        
> >>  
> >>>        
> >>  
> >   
> 

