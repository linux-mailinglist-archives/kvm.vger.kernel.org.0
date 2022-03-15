Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5114F4D94DE
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 07:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345295AbiCOGwf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 02:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240312AbiCOGwc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 02:52:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276EC49933;
        Mon, 14 Mar 2022 23:51:21 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22F6dp05018125;
        Tue, 15 Mar 2022 06:51:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=2d6ePSyHgcq1bsBV+mIoenMwALUumiHuZ1d6cq93HxY=;
 b=HrUk3DENgv2KrhFpxRJBQ31O3vwWUSv5Cx1v6M1iMt4TiM+7h89Is2cRDYWCv3QAy0F8
 ivsya/NslaazUzmPw3484PXCKP7lFKgQ6Mggs0VvOXmVdcvixjTjTLyDF5BTN+WT5cdo
 ndHdZyghfJ5vBzV+lP0zoERSsWKMY7xa9IF/oEmQ0+sP0LwL5Rfzw3KpTC8sctF1AyCV
 UvUp0REOMKIeFddrdLRlbCouQqaQIH7D+ZuDyShEICeJ+cRfPu/3eiz4jNiukC2cgSGL
 F+ziO+n2NQMUOgLry1Ii3vxIuDE7Z2oGrXk3OFCQkLHUGEo7zTcomF+xBD+YciytBbvV rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3etdvgg24n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 06:51:20 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22F6pKId004969;
        Tue, 15 Mar 2022 06:51:20 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3etdvgg242-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 06:51:20 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22F6hZaj004669;
        Tue, 15 Mar 2022 06:51:17 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3erk58n0vw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 06:51:17 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22F6pEsw47186300
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 06:51:14 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A35211C340;
        Tue, 15 Mar 2022 06:51:14 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D097311C274;
        Tue, 15 Mar 2022 06:51:13 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.5.92])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 15 Mar 2022 06:51:13 +0000 (GMT)
Message-ID: <eee8f2c52cfa6bd0ae423f64435f3a271335b1a4.camel@linux.ibm.com>
Subject: Re: [PATCH kvm-unit-tests v2 5/6] s390x: smp: Create and use a
 non-waiting CPU restart
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Tue, 15 Mar 2022 07:51:13 +0100
In-Reply-To: <20220311173822.1234617-6-farman@linux.ibm.com>
References: <20220311173822.1234617-1-farman@linux.ibm.com>
         <20220311173822.1234617-6-farman@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: h7uAQ3tJanuTBHdKpX6OxxA3GQ1s2ZLo
X-Proofpoint-GUID: WjdwvTvmV2LAnE7XLfUMW2dYU52L89q2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_14,2022-03-14_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 adultscore=0 bulkscore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1015 phishscore=0 priorityscore=1501
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203150042
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-03-11 at 18:38 +0100, Eric Farman wrote:
> The kvm-unit-tests infrastructure for a CPU restart waits for the
> SIGP RESTART to complete. In order to test the restart itself,
> create a variation that does not wait, and test the state of the
> CPU directly.
> 
> While here, add some better report prefixes/messages, to clarify
> which condition is being examined (similar to
> test_stop_store_status()).
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
