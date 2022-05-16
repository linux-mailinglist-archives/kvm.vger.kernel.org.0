Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBCB3527E7F
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 09:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240888AbiEPHWW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 03:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241072AbiEPHWR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 03:22:17 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1696B17E2D;
        Mon, 16 May 2022 00:22:17 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24G706BE028147;
        Mon, 16 May 2022 07:22:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=JuifCVkDQVVjp5OiuUeBAJSqFCJKTFUDHWj8OJinmXY=;
 b=BvhKjElgYoixjN4+jK1B9Xv0b7e781SmVCBZn6db3XUxcvkA1VVW08xOPh9tYlWBKpBn
 I9gl48FD+C9tU0tVBp0UQKtZAtUAlNrwzTzVkg1iUy+jlA6HVMK7O/2a3g0b4Z7rk0HY
 YJz83rU4d/yiZ7N2AGdHOKi4dik0DT+XWDFgDDdViGyMB8t2o1UonxikAfGt9PdcmLyI
 mi7Y5nssECjujsTdnyzd/PmvyfR8+WJIr8IMnwvEaFRL2Rw6+C203Ekrzym4IF6lFfYc
 z5mCxsJd8DjDv73IpkZhl0buk0qp4AlDVuNlx+1Tk+2SYlUGLLUl38YfMiePTZBh7rsQ 9A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3hub8ejt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 07:22:16 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24G7KW4A016681;
        Mon, 16 May 2022 07:22:15 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3hub8ejh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 07:22:15 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24G7IeDh009659;
        Mon, 16 May 2022 07:22:13 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3g2428hqc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 07:22:13 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24G7MAmC42271212
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 07:22:10 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 568E04C040;
        Mon, 16 May 2022 07:22:10 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC2454C046;
        Mon, 16 May 2022 07:22:09 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.50.122])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 May 2022 07:22:09 +0000 (GMT)
Message-ID: <560068a1e89c2ceec0d544fcc62fa3f95d390182.camel@linux.ibm.com>
Subject: Re: [PATCH v10 01/19] KVM: s390: pv: leak the topmost page table
 when destroy fails
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com
Date:   Mon, 16 May 2022 09:22:09 +0200
In-Reply-To: <20220414080311.1084834-2-imbrenda@linux.ibm.com>
References: <20220414080311.1084834-1-imbrenda@linux.ibm.com>
         <20220414080311.1084834-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: d8qLD7uyqhbqj5ReGRJQ2wqDuSMOFLRJ
X-Proofpoint-GUID: 2_6L4MdguNWF1gvqBaY5Vy4ZAXzAMDb_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_03,2022-05-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 clxscore=1011 priorityscore=1501 adultscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205160036
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-14 at 10:02 +0200, Claudio Imbrenda wrote:

[...]
> +/**
> + * s390_replace_asce - Try to replace the current ASCE of a gmap
> with
> + * another equivalent one.
> + * @gmap the gmap
> + *
> + * If the allocation of the new top level page table fails, the ASCE
> is not
> + * replaced.
> + * In any case, the old ASCE is always removed from the list.
> Therefore the
> + * caller has to make sure to save a pointer to it beforehands,
> unless an
> + * intentional leak is intended.
> + */
> +int s390_replace_asce(struct gmap *gmap)
> +{
>=20
[...]
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* Set new table origin while =
preserving existing ASCE
> control bits */
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0asce =3D (gmap->asce & ~_ASCE_=
ORIGIN) | __pa(table);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0WRITE_ONCE(gmap->asce, asce);

Can someone concurrently touch the control bits?

