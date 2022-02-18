Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17C774BBBE5
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 16:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236870AbiBRPK5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 10:10:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236931AbiBRPKt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 10:10:49 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B4D8EB42;
        Fri, 18 Feb 2022 07:10:33 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21IEA1jJ008943;
        Fri, 18 Feb 2022 15:10:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=pp1;
 bh=VJMyHQpNaPp9AK4RDuIY02Un/fcRi0eN3o4etWqjQ3Y=;
 b=fvMXqC4wcRGzveY5dK5YqiEfOPO7Y9CIZYKFSHEYh7SPJNeRX6m3DXzrbWn6mQiT/g6V
 pkLukVuGLY6q4YVi6uX6q1F+zMzDiTJhnSk1YEQnaLZ7JWfkBdwB4nqgDWXNBhmEdFxO
 4fkJNXfXN5asQv8BGODXvuIf7xIzi2koy/Ap76mdg+nAz+kHRka+3u86Vey2kHOf8WKB
 7BtLINRbbJGkodR8VfFjyDNnnZv3wLD609XvRgpGB+zU6RAOmLst61q7QAv4xAVfVpiT
 XplAd6mbXNe4fVuK6tSWPqzhqbowUjsA9QkjfK+ZLp+MkZcstRh+yOKzUW5zNwfD67cq Xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eaat8cm74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Feb 2022 15:10:32 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21IEj5gr018205;
        Fri, 18 Feb 2022 15:10:31 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eaat8cm65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Feb 2022 15:10:31 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21IF6J0J020196;
        Fri, 18 Feb 2022 15:10:30 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3e64hag7pn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Feb 2022 15:10:29 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21IFAPas45154620
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Feb 2022 15:10:25 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2719711C054;
        Fri, 18 Feb 2022 15:10:25 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9120611C04A;
        Fri, 18 Feb 2022 15:10:24 +0000 (GMT)
Received: from osiris (unknown [9.145.51.53])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 18 Feb 2022 15:10:24 +0000 (GMT)
Date:   Fri, 18 Feb 2022 16:10:23 +0100
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        gor@linux.ibm.com, wintera@linux.ibm.com, seiden@linux.ibm.com
Subject: Re: [PATCH v7 1/1] s390x: KVM: guest support for topology function
Message-ID: <Yg+23xh7DDSRHFxK@osiris>
References: <20220217095923.114489-1-pmorel@linux.ibm.com>
 <20220217095923.114489-2-pmorel@linux.ibm.com>
 <f0bf737abf480d6d16af6e5335bb195061f3d076.camel@linux.ibm.com>
 <97af6268-ff7a-cfb6-5ea4-217b5162cfe7@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <97af6268-ff7a-cfb6-5ea4-217b5162cfe7@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: c--EZ9ragR0pUMDp0BQZjVC39f2wLd3E
X-Proofpoint-GUID: pa9qOv8mcWP_CiW0IB5mxPbtIFo_nt2L
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-18_06,2022-02-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 mlxlogscore=856
 mlxscore=0 malwarescore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202180098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > > +       /* The real CPU backing up the vCPU moved to another socket
> > > */
> > > +       if (topology_physical_package_id(vcpu->cpu) !=
> > > +           topology_physical_package_id(vcpu->arch.prev_cpu))
> > > +               return true;
> > 
> > Why is it OK to look just at the physical package ID here? What if the
> > vcpu for example moves to a different book, which has a core with the
> > same physical package ID?
> > 
> 
> You are right, we should look at the drawer and book id too.
> Something like that I think:
> 
>         if ((topology_physical_package_id(vcpu->cpu) !=
>              topology_physical_package_id(vcpu->arch.prev_cpu)) ||
>             (topology_book_id(vcpu->cpu) !=
>              topology_book_id(vcpu->arch.prev_cpu)) ||
>             (topology_drawer_id(vcpu->cpu) !=
>              topology_drawer_id(vcpu->arch.prev_cpu)))
>                 return true;

You only need to check if prev_cpu is present in topology_core_cpumask(cpu).
