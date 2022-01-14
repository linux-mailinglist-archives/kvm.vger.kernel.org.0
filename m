Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 038FB48EAFC
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 14:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241372AbiANNn6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 08:43:58 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57538 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230472AbiANNn6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 08:43:58 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20ECqcXs028697;
        Fri, 14 Jan 2022 13:43:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=KMUztCrCWFgxtFLl9NgyGpfuhUslj7aMVbrW3LIdC7k=;
 b=cwSO8LrHhYQzRWzjKTtdHCfQpDXIOMhDNW5Om25HV+LHyO1yM97FVo/zTwXU98ADXgjq
 gLuF4HemDgnJJoaA/7R6192HQS3dHo37zMu7YAqSn9SVy3UBw9ozIIUIzogibHItYK/v
 8/gWQ0qBs8VTmqWGgTELHrL71QxxvjQQxGn4Dqirg3pdXWKZsehw9672R289QhsodEcC
 SWhuQ/JXM575tEjIXvdLr2r00faf8hHS3Zhj8NvIw2gfY64U1eO3kLSzXyCbKKrQMz48
 O/op+na+oF8rxJrgYweMKImmafUR+UY40SCXnStHAceOxvDkJvXDv6/HpEvlyzx2ZWmn +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dk9jm0yy2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 13:43:57 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20ECs49e032639;
        Fri, 14 Jan 2022 13:43:57 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dk9jm0yxh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 13:43:57 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EDbSEI022394;
        Fri, 14 Jan 2022 13:43:54 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3df28a3ses-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 13:43:54 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EDhpSc45547994
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 13:43:51 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64484AE055;
        Fri, 14 Jan 2022 13:43:51 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09824AE045;
        Fri, 14 Jan 2022 13:43:51 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.38.143])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 13:43:50 +0000 (GMT)
Message-ID: <5582205fd65db8fcfd9ba94e2976007e7ac4869d.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 1/5] lib: s390x: vm: Add kvm and lpar vm
 queries
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Date:   Fri, 14 Jan 2022 14:43:50 +0100
In-Reply-To: <d09a7170-6538-fc52-15f1-42d7fc4e7c9b@linux.ibm.com>
References: <20220114100245.8643-1-frankja@linux.ibm.com>
         <20220114100245.8643-2-frankja@linux.ibm.com>
         <b468354deac3f9902f42aa2c46e762ddf208efdd.camel@linux.ibm.com>
         <d09a7170-6538-fc52-15f1-42d7fc4e7c9b@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ynb9lVlfBB_gSATIsxHtSiFAeBX-tyUD
X-Proofpoint-ORIG-GUID: a_G_FRUj6QdPy_RQ2GvU6dfWCsYNhkAM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_05,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=969 mlxscore=0 bulkscore=0 phishscore=0 impostorscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501
 adultscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201140090
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-01-14 at 14:35 +0100, Janosch Frank wrote:
> Have a look at Pierre's patch which I will be relying on when it's
> done. 
> As I said in the commit message, this is only a placeholder for his
> patch.

There it is just as I suggested. Thanks.
