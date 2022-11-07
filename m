Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D300561F280
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 13:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbiKGMHO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 07:07:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbiKGMG6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 07:06:58 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BBF1ADB5;
        Mon,  7 Nov 2022 04:06:56 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7AIAbl024878;
        Mon, 7 Nov 2022 12:06:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : from
 : to : cc : subject : message-id : date; s=pp1;
 bh=EDvGDf28VbTzP+7su1ivJ6c6Rn9MDj1y3cndFJJP/fk=;
 b=FO2z5xzrYEECGe4DFnNzvZoTDc7BlZYSInv/mE+Nuaslw7L1v3HSAP9/SKBznTTWQFwU
 ynr0d1PFkkozZmCOPxa9Of+BGQsV7gf9dUI14elL/VY2aoWW1zTmh0ZY3HHtBHZQuC9Y
 hobI3IKFLjU6eNYaHQ8kiEybe+UgfjGzVLme3yr7UlcF1aoMjlAZIfNKvM/lIG43Gt2v
 5fbijJD4poDkR5P64YorLEUvml7Jux1T0p2QK72KGpSuR76L4s/+Yv2z8xmBLIxYLZB2
 Xn6+oTpBg5YRqlMMNXXvVFWpgjd5MyrYiWxPtlAYI0NI9DyiQ6r+pwMKDtUX5Bu4QR6E hg== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kp8bf1wd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 12:06:55 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A7C55Xo016437;
        Mon, 7 Nov 2022 12:06:53 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3kngqdahqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Nov 2022 12:06:53 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A7C6oVq60948772
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Nov 2022 12:06:50 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF32811C04C;
        Mon,  7 Nov 2022 12:06:49 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D36B111C052;
        Mon,  7 Nov 2022 12:06:49 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.95.240])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Nov 2022 12:06:49 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <86aa57d3-e92e-4846-8676-cb2f93dcf59c@linux.ibm.com>
References: <20221107105843.6641-1-nrb@linux.ibm.com> <86aa57d3-e92e-4846-8676-cb2f93dcf59c@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v1] s390/mm: fix virtual-physical address confusion for swiotlb
Message-ID: <166782280962.18806.18113766775569802651@t14-nrb>
User-Agent: alot/0.8.1
Date:   Mon, 07 Nov 2022 13:06:49 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NOk-svvDwpUiyzzmaF1JiIcXf_ZIqIvF
X-Proofpoint-ORIG-GUID: NOk-svvDwpUiyzzmaF1JiIcXf_ZIqIvF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_04,2022-11-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 priorityscore=1501 suspectscore=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=900 bulkscore=0 spamscore=0 malwarescore=0 phishscore=0
 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211070099
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Christian Borntraeger (2022-11-07 12:21:58)
> Am 07.11.22 um 11:58 schrieb Nico Boehr:
> > swiotlb passes virtual addresses to set_memory_encrypted() and
> > set_memory_decrypted(), but uv_remove_shared() and uv_set_shared()
> > expect physical addresses. This currently works, because virtual
> > and physical addresses are the same.
> >=20
> > Add virt_to_phys() to resolve the virtual-physical confusion.
> >=20
> > Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
>=20
> Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
>=20
> I am asking myself if we should rename addr to vaddr to make this more ob=
vious.
> (Other users of these functions do use vaddr as well).

I had this at some point, but then changed it back because at the time I
thought we don't own the prototype.

However, looking at it again, it looks like that's wrong and we do own
it in arch/s390/include/asm/mem_encrypt.h.

So I think it's a good suggestion and I will pick it up for v2.
