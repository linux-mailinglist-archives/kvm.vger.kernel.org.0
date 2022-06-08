Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F010B542FB5
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 14:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238539AbiFHMDh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 08:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238432AbiFHMDe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 08:03:34 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD86C22BD5;
        Wed,  8 Jun 2022 05:03:31 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 258BrFoM021092;
        Wed, 8 Jun 2022 12:03:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=xIqrvvlax9jQ3eIbCaFoGQQ5ed3wBavfB+LjSosazDU=;
 b=HBQMyyE9mArgiTH2d0qTlJ50qooFCV+EtTQjxwj9CLYBCA32fhP4DjuvCZHKxX/dOFN8
 +KuuSFDaTSKocXLEU3dTo4s1rJlA3ob5EDVUtP3vTZyL/5yXccqeVHn8vpUcd4xPqsgh
 T1NoYZnA4na/j06MLc1XzFP7abM+74+8wmwT0oKmXDzmdtEmLoUBB41NviIF1FZawZoT
 06auU9wrzsVnyEgqIRMrKc0EoG3abqtcygIAUauXzEv+gZEgxxlzIqqBblEbfdGfD4Iq
 OBjsYAXktoum73iEB6Sxfm5r7pJX3lLBCl95jBPM+0TknXFl6fwQhi2JupArtAJWdsoz jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjstq1xy2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 12:03:30 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 258BvESC008992;
        Wed, 8 Jun 2022 12:03:30 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gjstq1xxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 12:03:30 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 258Bpw1f025071;
        Wed, 8 Jun 2022 12:03:28 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3gfy18v133-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Jun 2022 12:03:28 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 258C3PuQ28508530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Jun 2022 12:03:25 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71E395204E;
        Wed,  8 Jun 2022 12:03:25 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1 (unknown [9.152.224.44])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2D36A52057;
        Wed,  8 Jun 2022 12:03:25 +0000 (GMT)
Date:   Wed, 8 Jun 2022 14:03:23 +0200
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        scgl@linux.ibm.com, mimu@linux.ibm.com
Subject: Re: [PATCH v11 11/19] s390/mm: KVM: pv: when tearing down, try to
 destroy protected pages
Message-ID: <20220608140323.0c46c0a2@li-ca45c2cc-336f-11b2-a85c-c6e71de567f1>
In-Reply-To: <20220603065645.10019-12-imbrenda@linux.ibm.com>
References: <20220603065645.10019-1-imbrenda@linux.ibm.com>
        <20220603065645.10019-12-imbrenda@linux.ibm.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MAME0xyuyz5yYozDYAbY2aKAJUvsZ4iP
X-Proofpoint-ORIG-GUID: Tpv7AVSoRSjx5mIYSNYcYTvM9Y-5VDgI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_03,2022-06-07_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 spamscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015 mlxlogscore=768
 impostorscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  3 Jun 2022 08:56:37 +0200
Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:

> When ptep_get_and_clear_full is called for a mm teardown, we will now
> attempt to destroy the secure pages. This will be faster than export.
> 
> In case it was not a teardown, or if for some reason the destroy page
> UVC failed, we try with an export page, like before.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Acked-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
