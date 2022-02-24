Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF86D4C2DE2
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 15:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235328AbiBXOJE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 09:09:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232103AbiBXOJD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 09:09:03 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF9B2221AE;
        Thu, 24 Feb 2022 06:08:33 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21OBaNsT030320;
        Thu, 24 Feb 2022 14:08:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=n2kxKD2h+WcGFAGalUUU4NOWH38cFeTHK0pR6BA0IRc=;
 b=fNopV5Rc3LIeG/dnb4BEavUH5S7FiCZrPPci7hZ6/9MZT1Jovgp//y8DMjeuTZf1qWQx
 rIw2dz/yt+Y71a5w6vrETuIWjrhvCSVxF+CiWmueqyLVe39YUqnrkNqAueBzG0pxlhvQ
 D8LHZmhqEbqYoqE+paFMWM4V+UyUaX6Yi+nFDL8JWQde3nzo9rYHZoEnE0pgidfM4FKg
 JEVg3CVUAA/2nsodyoAnetCvsRtvzWm4K7M+Pfoj3SKyzgLrCOuMn3dYW1dwTWWB0Uwd
 okoYcmDNleRlbXkdzmZLACms31ICmY/cBXbpXNIDqRUfYXsIgJcYSdJ8h+DfNURbe/SO lA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edpjvbvqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 14:08:33 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21ODIZj6018691;
        Thu, 24 Feb 2022 14:08:32 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edpjvbvpm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 14:08:32 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21ODx5T9007604;
        Thu, 24 Feb 2022 14:08:30 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3ear69g79v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Feb 2022 14:08:29 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21OE8Ne254198558
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Feb 2022 14:08:23 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 939EF11C04A;
        Thu, 24 Feb 2022 14:08:23 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B4FB11C05C;
        Thu, 24 Feb 2022 14:08:23 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.55.52])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu, 24 Feb 2022 14:08:23 +0000 (GMT)
Date:   Thu, 24 Feb 2022 15:08:20 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        Pierre Morel <pmorel@linux.ibm.com>, thuth@redhat.com,
        david@redhat.com, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 6/8] s390x: Add more tests for STSCH
Message-ID: <20220224150820.3c20ff8d.pasic@linux.ibm.com>
In-Reply-To: <04daca6a-5863-d205-ea98-096163a2296a@linux.ibm.com>
References: <20220223132940.2765217-1-nrb@linux.ibm.com>
        <20220223132940.2765217-7-nrb@linux.ibm.com>
        <04daca6a-5863-d205-ea98-096163a2296a@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: V5aD4fVHh9mbg_Fmgc-QSSy7vg2L55DQ
X-Proofpoint-GUID: bZQJpEGYvt2dz37C00wgWtm9mjm-pu-5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-24_02,2022-02-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 adultscore=0 clxscore=1011 mlxscore=0
 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=892
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202240084
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 23 Feb 2022 16:39:07 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> We could check if bits 0,1 and 6,7 are also zero but I'm not sure if 
> that's interesting since MSCH does not ignore those bits and should 
> result in an operand exception when trying to set them.
> 
> @Halil, @Pierre: Any opinions?

IMHO more testing doesn't hurt. But I don't have clarity on some aspect
of how the architecture is extended. What I'm trying to say is: I'm not
100% certain these bits must stay 0 and no-semantics-defined forever.

Regards,
Halil
